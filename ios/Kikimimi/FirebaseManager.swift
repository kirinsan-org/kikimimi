//
//  FirebaseManager.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import Foundation
import Firebase
import FirebaseInstanceID

final class FirebaseManager {
	static let sharedInstance = FirebaseManager()

	private(set) var commands: [Command] = []

	enum Event {
		case CommandListChanged([Command])
		case DetectedCommandChanged(Command)
	}

	typealias EventObserver = (Event) -> Void
	private var eventObservers: [EventObserver] = []

	private var deviceRef: FIRDatabaseReference?
	private var commandRef: FIRDatabaseReference?

	init() {
		FIRInstanceID.instanceID().getIDWithHandler { id, error in
			guard let id = id else {
				print("Failed to get instance ID with error: \(error)")
				return
			}

			let deviceRef = FIRDatabase.database().referenceWithPath("device/\(id)")
			deviceRef.child("detectedCommand").observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
				guard let json = snapshot.value as? [String : AnyObject] else {
					print("Invalid value for \(snapshot.ref.URL)")
					return
				}
				print("detectedCommand changed \(json)")
			})
			self.deviceRef = deviceRef

			let commandRef = FIRDatabase.database().referenceWithPath("command")
			commandRef.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
				guard let json = snapshot.value as? [String : [String : AnyObject]] else {
					print("Invalid value for \(snapshot.ref.URL)")
					return
				}
				let commands = json.flatMap({ (key, value) -> Command? in
					guard
						let name = value["name"] as? String,
						let action = value["action"] as? String,
						let categoryValue = value["category"] as? Int,
						let category = CommandCategory(rawValue: categoryValue) else {
						return nil
					}
					return Command(id: key, name: name, action: action, category: category)
				})
				self.commands = commands
				self.triggerEvent(.CommandListChanged(commands))
			})
			self.commandRef = commandRef
		}
	}

	func registerCommand(name: String, action: String, category: CommandCategory, recordedData: [FFTData]) -> Command {
		guard let ref = commandRef?.childByAutoId() else {
			fatalError()
		}

		ref.child("name").setValue(name)
		ref.child("action").setValue(action)
		ref.child("category").setValue(category.rawValue)

		let audioDataRef = ref.child("audioData")
		recordedData.forEach { data in
			audioDataRef.childByAutoId().setValue(data.values)
		}

		return Command(id: ref.key, name: name, action: action, category: category)
	}

	func pushRecordedFFTData(data: FFTData) {
		deviceRef?.child("recordedData").setValue(data.values)
	}

	func observerEvent(observer: EventObserver) {
		eventObservers.append(observer)
	}

	private func triggerEvent(event: Event) {
		eventObservers.forEach({ $0(event) })
	}
}

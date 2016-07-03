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
				guard let id = snapshot.value as? String else {
					print("Invalid value for \(snapshot.ref.URL)")
					return
				}
				let ref = self.commandRef!.child(id)
				ref.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
					guard let json = snapshot.value as? [String : AnyObject], let command = Command(id: id, json: json) else {
						return
					}
					self.triggerEvent(.DetectedCommandChanged(command))
				})
			})
			self.deviceRef = deviceRef

			let commandRef = FIRDatabase.database().referenceWithPath("command")
			commandRef.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
				guard let json = snapshot.value as? [String : [String : AnyObject]] else {
					print("Invalid value for \(snapshot.ref.URL)")
					return
				}
				let commands = json.flatMap({ (key, value) -> Command? in
					return Command(id: key, json: value)
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

extension Command {
	init?(id: String, json: [String : AnyObject]) {
		guard
			let name = json["name"] as? String,
			let action = json["action"] as? String,
			let categoryValue = json["category"] as? Int,
			let category = CommandCategory(rawValue: categoryValue) else {
				return nil
		}
		self = Command(id: id, name: name, action: action, category: category)
	}
}

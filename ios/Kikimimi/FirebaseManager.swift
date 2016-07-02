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

	enum Event {
		case DetectedCommandChanged(Command)
	}

	typealias EventObserver = (Event) -> Void
	private var eventObservers: [EventObserver] = []

	typealias DetectedCommandObserver = (Command) -> Void
	private var detectedCommandObservers: [DetectedCommandObserver] = []

	private var firebaseRef: FIRDatabaseReference?

	init() {
		FIRInstanceID.instanceID().getIDWithHandler { id, error in
			guard let id = id else {
				print("Failed to get instance ID with error: \(error)")
				return
			}
			self.firebaseRef = FIRDatabase.database().referenceWithPath("device/\(id)")
		}
	}

	func pushRecordedFFTData(data: FFTData) {
		firebaseRef?.child("recordedData").setValue(data.values)
	}

	func observerEvent(observer: EventObserver) {
		eventObservers.append(observer)
	}

	private func triggerEvent(event: Event) {
		eventObservers.forEach({ $0(event) })
	}
}

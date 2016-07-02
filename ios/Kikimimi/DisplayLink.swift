//
//  DisplayLink.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/2/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import QuartzCore

final class DisplayLink: NSObject {
	typealias UpdateHandler = (timestamp: CFTimeInterval, duration: CFTimeInterval) -> Void

	private let _updateHandler: UpdateHandler
	private var _displayLink: CADisplayLink!

	var paused: Bool {
		get { return _displayLink.paused }
		set(value) { _displayLink.paused = value }
	}

	init(update: UpdateHandler) {
		_updateHandler = update

		super.init()

		_displayLink = CADisplayLink(target: self, selector: #selector(DisplayLink.update(_:)))
		_displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
	}

	func update(sender: CADisplayLink) {
		_updateHandler(timestamp: sender.timestamp, duration: sender.duration)
	}
}

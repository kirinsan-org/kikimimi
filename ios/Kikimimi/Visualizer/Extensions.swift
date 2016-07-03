//
//  Extensions.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import SpriteKit

extension Int {
	
	var decreased: Int {
		return self.advancedBy(-1)
	}
	
	var increased: Int {
		return self.advancedBy(1)
	}
	
}

extension CGFloat {
	
	static func createRandom(`in` interval: ClosedInterval<CGFloat> = 0 ... 1) -> CGFloat {
		
		let intervalWidth = interval.end - interval.start
		let randomUInt32 = arc4random_uniform(1024)
		let random = CGFloat(randomUInt32) / CGFloat(1024)
		
		return random * intervalWidth + interval.start
		
	}
	
}

extension CGPoint {
	
	static func createRandom(x x: ClosedInterval<CGFloat> = 0 ... 1, y: ClosedInterval<CGFloat> = 0 ... 1) -> CGPoint {
		
		let x = CGFloat.createRandom(in: x)
		let y = CGFloat.createRandom(in: y)
		
		return CGPoint(x: x, y: y)
		
	}
	
}

extension CGRect {
	
	var top: CGFloat {
		return self.origin.y
	}
	
	var bottom: CGFloat {
		return self.origin.y + self.height
	}
	
	var left: CGFloat {
		return self.origin.x
	}
	
	var right: CGFloat {
		return self.origin.x + self.width
	}
	
}

extension UIColor {
	
	convenience init(hexRGBAValue value: Int) {
		
		let intRed = (value >> 24) & 0xFF
		let intGreen = (value >> 16) & 0xFF
		let intBlue = (value >> 8) & 0xFF
		let intAlpha = (value >> 0) & 0xFF
		
		let red = CGFloat(intRed) / CGFloat(0xFF)
		let green = CGFloat(intGreen) / CGFloat(0xFF)
		let blue = CGFloat(intBlue) / CGFloat(0xFF)
		let alpha = CGFloat(intAlpha) / CGFloat(0xFF)
		
		self.init(red: red, green: green, blue: blue, alpha: alpha)
		
	}
	
}

extension SKAction {
	
	static func eternalMove(byX x: CGFloat, y: CGFloat) -> SKAction {
		
		let moveAction = SKAction.moveByX(x, y: y, duration: 1)
		let repeatedAction = SKAction.repeatActionForever(moveAction)
		
		return repeatedAction
		
	}
	
	static func eternalMove(byX x: ClosedInterval<CGFloat>, y: ClosedInterval<CGFloat>) -> SKAction {
		
		let moveAction = SKAction.moveByX(.createRandom(in: x), y: .createRandom(in: y), duration: 1)
		let repeatedAction = SKAction.repeatActionForever(moveAction)
		
		return repeatedAction
		
	}
	
}

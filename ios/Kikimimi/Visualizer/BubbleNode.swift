//
//  BubbleNode.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import SpriteKit

class BubbleNode: SKShapeNode {
	
	init(radius: CGFloat) {
		
		super.init()
		
		let r = radius
		let rect = CGRect(x: -r, y: -r, width: r * 2, height: r * 2)
		self.path = CGPathCreateWithEllipseInRect(rect, nil)
		self.alpha = 1
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension BubbleNode {
	
	func setAction(action: SKAction) {
		self.removeAllActions()
		self.runAction(action)
	}
	
}

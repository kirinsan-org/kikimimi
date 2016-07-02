//
//  VisualizerScene.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import SpriteKit

protocol VisualizerSceneDataSource: class {
	func getBubbleSettings() -> [UIColor]
	func getBubbleScales() -> [CGFloat]
}

class VisualizerScene: SKScene {
	
	weak var dataSource: VisualizerSceneDataSource?
	private let moveActionSpeed: CGFloat = 50
	
	override func didMoveToView(view: SKView) {
		
		let radius: CGFloat = min(self.frame.width, self.frame.height) / 5
		
		let bubbleSettings = self.dataSource?.getBubbleSettings() ?? []
		bubbleSettings.forEach { (color) in
			let node = BubbleNode(radius: radius)
			node.lineWidth = 2
			node.fillColor = SKColor(CGColor: color.CGColor)
			node.strokeColor = .cyanColor()
			node.position = .createRandom(x: radius ... self.size.width - radius, y: radius ... self.size.height - radius)
			
			let speed = self.moveActionSpeed
			let moveAction = SKAction.moveBy(CGVector(dx: .createRandom(in: -speed ... speed), dy: .createRandom(in: -speed ... speed)), duration: 1)
			let repeatedAction = SKAction.repeatActionForever(moveAction)
			node.runAction(repeatedAction)
			
			self.addChild(node)
		}
		
	}
	
	override func update(currentTime: NSTimeInterval) {
		
		let speed = self.moveActionSpeed
		let scales = self.dataSource?.getBubbleScales() ?? []
		
		self.children.flatMap({ (node) -> BubbleNode? in
			return node as? BubbleNode
		}).enumerate().forEach({ (i, bubble) in
			
			if i < scales.count {
				bubble.setScale(scales[i])
			} else {
				bubble.setScale(0.5)
			}
			
			if bubble.frame.top <= self.frame.top && bubble.frame.left <= self.frame.left {
				let action = SKAction.eternalMove(byX: 0 ... speed, y: 0 ... speed)
				bubble.removeAllActions()
				bubble.runAction(action)
				
			} else if bubble.frame.top <= self.frame.top && bubble.frame.right >= self.frame.right {
				let action = SKAction.eternalMove(byX: -speed ... 0, y: 0 ... speed)
				bubble.removeAllActions()
				bubble.runAction(action)
				
			} else if bubble.frame.bottom >= self.frame.bottom && bubble.frame.left <= self.frame.left {
				let action = SKAction.eternalMove(byX: 0 ... speed, y: -speed ... 0)
				bubble.removeAllActions()
				bubble.runAction(action)
				
			} else if bubble.frame.bottom >= self.frame.bottom && bubble.frame.right >= self.frame.right {
				let action = SKAction.eternalMove(byX: -speed ... 0, y: -speed ... 0)
				bubble.removeAllActions()
				bubble.runAction(action)
				
			} else if bubble.frame.top <= self.frame.top {
				let action = SKAction.eternalMove(byX: -speed ... speed, y: 0 ... speed)
				bubble.removeAllActions()
				bubble.runAction(action)
				
			} else if bubble.frame.bottom >= self.frame.bottom {
				let action = SKAction.eternalMove(byX: -speed ... speed, y: -speed ... 0)
				bubble.removeAllActions()
				bubble.runAction(action)
				
			} else if bubble.frame.left <= self.frame.left {
				let action = SKAction.eternalMove(byX: 0 ... speed, y: -speed ... 10)
				bubble.removeAllActions()
				bubble.runAction(action)
				
			} else if bubble.frame.right >= self.frame.right {
				let action = SKAction.eternalMove(byX: -speed ... 0, y: -speed ... speed)
				bubble.removeAllActions()
				bubble.runAction(action)
				
			}
			
		})
		
	}
	
}

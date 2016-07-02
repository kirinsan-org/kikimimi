//
//  VisualizerScene.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import SpriteKit

protocol VisualizerSceneDataSource: class {
	func getFFTSampleArray() -> [Double]
}

class VisualizerScene: SKScene {
	
	weak var dataSource: VisualizerSceneDataSource?
	
	override func didMoveToView(view: SKView) {
		
		let radius: CGFloat = 50
		
		(0 ..< 32).forEach { (_) in
			let node = BubbleNode(radius: radius)
			node.lineWidth = 2
			node.fillColor = SKColor(red: 0.9, green: 0.2, blue: 0.3, alpha: 0.5)
			node.strokeColor = .cyanColor()
			node.position = .createRandom(x: radius ... self.size.width - radius, y: radius ... self.size.height - radius)
			
			let moveAction = SKAction.moveBy(CGVector(dx: .createRandom(in: -10 ... 10), dy: .createRandom(in: -10 ... 10)), duration: 1)
			let repeatedAction = SKAction.repeatActionForever(moveAction)
			node.runAction(repeatedAction)
			self.addChild(node)
		}
		
	}
	
	override func update(currentTime: NSTimeInterval) {
		
		for child in children {
			
			switch child {
			case let bubble as BubbleNode:
				if bubble.frame.top <= self.frame.top && bubble.frame.left <= self.frame.left {
					let action = SKAction.eternalMove(byX: 0 ... 10, y: 0 ... 10)
					bubble.removeAllActions()
					GCD.runAsynchronizedQueue(with: { 
						bubble.runAction(action)
					})
					
				} else if bubble.frame.top <= self.frame.top && bubble.frame.right >= self.frame.right {
					let action = SKAction.eternalMove(byX: -10 ... 0, y: 0 ... 10)
					bubble.removeAllActions()
					GCD.runAsynchronizedQueue(with: {
						bubble.runAction(action)
					})
					
				} else if bubble.frame.bottom >= self.frame.bottom && bubble.frame.left <= self.frame.left {
					let action = SKAction.eternalMove(byX: 0 ... 10, y: -10 ... 0)
					bubble.removeAllActions()
					GCD.runAsynchronizedQueue(with: {
						bubble.runAction(action)
					})
					
				} else if bubble.frame.bottom >= self.frame.bottom && bubble.frame.right >= self.frame.right {
					let action = SKAction.eternalMove(byX: -10 ... 0, y: -10 ... 0)
					bubble.removeAllActions()
					GCD.runAsynchronizedQueue(with: {
						bubble.runAction(action)
					})
					
				} else if bubble.frame.top <= self.frame.top {
					let action = SKAction.eternalMove(byX: -10 ... 10, y: 0 ... 10)
					bubble.removeAllActions()
					GCD.runAsynchronizedQueue(with: {
						bubble.runAction(action)
					})
					
				} else if bubble.frame.bottom >= self.frame.bottom {
					let action = SKAction.eternalMove(byX: -10 ... 10, y: -10 ... 0)
					bubble.removeAllActions()
					GCD.runAsynchronizedQueue(with: {
						bubble.runAction(action)
					})
					
				} else if bubble.frame.left <= self.frame.left {
					let action = SKAction.eternalMove(byX: 0 ... 10, y: -10 ... 10)
					bubble.removeAllActions()
					GCD.runAsynchronizedQueue(with: {
						bubble.runAction(action)
					})
					
				} else if bubble.frame.right >= self.frame.right {
					let action = SKAction.eternalMove(byX: -10 ... 0, y: -10 ... 10)
					bubble.removeAllActions()
					GCD.runAsynchronizedQueue(with: {
						bubble.runAction(action)
					})
					
				}
				
			default:
				break
			}
			
		}
		
	}
	
}

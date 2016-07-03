//
//  VisualizerScene.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import SpriteKit

protocol VisualizerSceneDataSource: class {
	func getBubbleSettings() -> [(fillColor: SKColor, strokeColor: SKColor)]
	func getBubbleScales() -> [CGFloat]
}

class VisualizerScene: SKScene {
	
	weak var dataSource: VisualizerSceneDataSource?
	private let moveActionSpeed: CGFloat = 50
	
	private var baseTime: NSTimeInterval = 0
	private var elapsedFrames: Int = 0
	
	override func didMoveToView(view: SKView) {
		
		let speed = self.moveActionSpeed
		
		self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		
		let radius: CGFloat = min(self.frame.width, self.frame.height) / 5
		
		do {
			let wall = SKShapeNode(rectOfSize: CGSize(width: self.frame.width, height: 1))
			wall.strokeColor = .clearColor()
			wall.fillColor = .clearColor()
			wall.position = CGPoint(x: self.frame.width / 2, y: 0)
			
			let body = SKPhysicsBody(rectangleOfSize: wall.frame.size)
			body.categoryBitMask = 0x1
			body.friction = 0
			body.restitution = 1
			body.dynamic = false
			wall.physicsBody = body
			self.addChild(wall)
		}
		
		do {
			let wall = SKShapeNode(rectOfSize: CGSize(width: self.frame.width, height: 1))
			wall.strokeColor = .clearColor()
			wall.fillColor = .clearColor()
			wall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
			
			let body = SKPhysicsBody(rectangleOfSize: wall.frame.size)
			body.categoryBitMask = 0x1
			body.friction = 0
			body.restitution = 1
			body.dynamic = false
			wall.physicsBody = body
			self.addChild(wall)
		}
		
		do {
			let wall = SKShapeNode(rectOfSize: CGSize(width: 1, height: self.frame.height))
			wall.strokeColor = .clearColor()
			wall.fillColor = .clearColor()
			wall.position = CGPoint(x: 0, y: self.frame.height / 2)
			
			let body = SKPhysicsBody(rectangleOfSize: wall.frame.size)
			body.categoryBitMask = 0x1
			body.friction = 0
			body.restitution = 1
			body.dynamic = false
			wall.physicsBody = body
			self.addChild(wall)
		}
		
		do {
			let wall = SKShapeNode(rectOfSize: CGSize(width: 1, height: self.frame.height))
			wall.strokeColor = .clearColor()
			wall.fillColor = .clearColor()
			wall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2)
			let body = SKPhysicsBody(rectangleOfSize: wall.frame.size)
			body.categoryBitMask = 0x1
			body.friction = 0
			body.restitution = 1
			body.dynamic = false
			wall.physicsBody = body
			self.addChild(wall)
		}
		
		let bubbleSettings = self.dataSource?.getBubbleSettings() ?? []
		bubbleSettings.forEach { (color) in
			let node = BubbleNode(radius: radius)
			node.lineWidth = 2
			node.fillColor = color.fillColor
			node.strokeColor = color.strokeColor
			node.position = .createRandom(x: radius ... self.size.width - radius, y: radius ... self.size.height - radius)
			node.setScale(0.5)
			
			let body = SKPhysicsBody(circleOfRadius: radius)
			let x = CGFloat.createRandom(in: -speed ... speed)
			let y = CGFloat.createRandom(in: -speed ... speed)
			body.velocity = CGVector(dx: x, dy: y)
			body.categoryBitMask = 0x0
			body.collisionBitMask = 0x1
			body.linearDamping = 0
			body.allowsRotation = false
			body.friction = 0
			body.restitution = 1
			node.physicsBody = body
			
			self.addChild(node)
		}
		
	}
	
	override func update(currentTime: NSTimeInterval) {
		
		guard self.baseTime != 0 else {
			self.baseTime = currentTime
			return
		}
		
		self.elapsedFrames += 1
		if self.elapsedFrames < 30 {
			return
		}
		
		let elapsedTime = currentTime - self.baseTime
		if elapsedTime > 0.2 {
			self.baseTime = currentTime
			self.setScaleForBubbles()
		}
		
	}
	
	private func setScaleForBubbles() {
		
		let scales = self.dataSource?.getBubbleScales() ?? []
		
		self.children.flatMap({ (node) -> BubbleNode? in
			return node as? BubbleNode
		}).enumerate().forEach({ (i, bubble) in
			
			if i < scales.count {
				let action = SKAction.scaleTo(scales[i], duration: 0.2)
				bubble.runAction(action)
			} else {
				let action = SKAction.scaleTo(0.5, duration: 0.2)
				bubble.runAction(action)
			}
			
		})
		
	}
	
}

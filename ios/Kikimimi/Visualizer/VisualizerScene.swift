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
		self.backgroundColor = .blackColor()
		
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
				let scale = scales[i]
				let action = SKAction.scaleTo(scale, duration: 0.2)
				bubble.runAction(action)
				
				if scale > 0.75 {
					if let node = SKEmitterNode(fileNamed: "spark.sks") {
						node.particleBirthRate = 200
						node.numParticlesToEmit = 40
						node.position = bubble.position
						node.setScale(0.3)
						
						self.addChild(node)
						
						let action = SKAction.fadeAlphaTo(0, duration: 1)
						node.runAction(action)
					}
				}
			} else {
				let action = SKAction.scaleTo(0.5, duration: 0.2)
				bubble.runAction(action)
			}
			
		})
		
	}
	
	func presentCommandIconSprite(sprite: SKSpriteNode) {
		
		var sprites = [Int](1 ... 4).map { (i) -> SKNode in
			let dummy = SKShapeNode(circleOfRadius: CGFloat(i) * 10)
			dummy.fillColor = .whiteColor()
			dummy.zPosition = 100
			return dummy
		}
		
		sprite.zPosition = 100
		sprite.setScale(150 / max(sprite.size.width, sprite.size.height))
		sprites.append(sprite)
		
		let xs: [CGFloat] = [20, -20, 20, -20, 0]
		let ys: [CGFloat] = [30, 70, 130, 210, 340]
		
		let fadeinAction = SKAction.fadeInWithDuration(0.3)
		let waitingAction = SKAction.waitForDuration(1.4)
		let fadeoutAction = SKAction.fadeOutWithDuration(0.3)
		sprites.enumerate().reverse().forEach { (i, node) in
			let x = (self.frame.width / 2) + xs[i]
			let y = 50 + ys[i]
			node.position = CGPoint(x: x, y: y)
			node.alpha = 0
			self.addChild(node)
			
			let delayAction = SKAction.waitForDuration(NSTimeInterval(i) * 0.2)
			let fadeAction = SKAction.sequence([delayAction, fadeinAction, waitingAction, fadeoutAction])
			let moveAction = SKAction.moveByX(0, y: 200, duration: 4)
			let action = SKAction.group([fadeAction, moveAction])
			node.runAction(action)
		}
		
	}
	
}

//
//  ProgressCircleView.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

final class ProgressCircleView: UIView {
	var shapeLayer: CAShapeLayer { return layer as! CAShapeLayer }

	var progress: CGFloat = 0 {
		didSet {
			updateProgress()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		shapeLayer.lineWidth = 15
		shapeLayer.strokeStart = 0
		shapeLayer.strokeEnd = 0
		shapeLayer.strokeColor = UIColor(white: 1, alpha: 1).CGColor
		shapeLayer.fillColor = UIColor.clearColor().CGColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override class func layerClass() -> AnyClass {
		return CAShapeLayer.self
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let center = CGPoint(x: bounds.midX, y: bounds.midY)
		let radius = min(bounds.width, bounds.height) / 2
		shapeLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true).CGPath
	}

	private func updateProgress() {
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.fromValue = (shapeLayer.presentationLayer() ?? shapeLayer).valueForKeyPath(animation.keyPath!)
		animation.toValue = progress
		animation.duration = 0.6
		animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
		shapeLayer.addAnimation(animation, forKey: "updateProgress")
		shapeLayer.strokeEnd = progress
	}
}

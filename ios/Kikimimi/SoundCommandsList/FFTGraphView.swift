//
//  FFTGraphView.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

final class FFTGraphView: UIView {
	var shapeLayer: CAShapeLayer { return layer as! CAShapeLayer }

	override init(frame: CGRect) {
		super.init(frame: frame)

		shapeLayer.lineWidth = 1
		shapeLayer.strokeColor = UIColor(white: 0.5, alpha: 1).CGColor
		shapeLayer.fillColor = UIColor.clearColor().CGColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var fftData: FFTData? {
		didSet {
			updateShape()
		}
	}

	override class func layerClass() -> AnyClass {
		return CAShapeLayer.self
	}

	private func updateShape() {
		let path = UIBezierPath()
		path.moveToPoint(CGPoint(x: bounds.minX, y: bounds.midY))

		if let data = fftData {
			let values = data.values[0...96]
			let interval = bounds.width / CGFloat(values.count)
			let maxHeight = bounds.height / 2
			for (i, value) in values.enumerate() {
				let point = CGPoint(x: interval * CGFloat(i), y: bounds.midY - maxHeight * CGFloat(value / 1))
				path.addLineToPoint(point)
			}
		} else {
			path.addLineToPoint(CGPoint(x: bounds.maxX, y: bounds.midY))
		}

		shapeLayer.path = path.CGPath
	}
}

//
//  CircleButton.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

final class CircleButton: UIButton {
	init(imageName: String) {
		super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))

		backgroundColor = UIColor(white: 0.5, alpha: 1)

		setImage(UIImage(named: imageName), forState: .Normal)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		clipsToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		layer.cornerRadius = min(bounds.width, bounds.height) / 2
	}
}

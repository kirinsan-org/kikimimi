//
//  SoundCommandCell.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

final class SoundCommandCell: UITableViewCell {
	let iconView = UIImageView()
	let nameLabel = UILabel()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		backgroundColor = UIColor.blackColor()
		accessoryType = .DisclosureIndicator

		contentView.addSubview(iconView)
		contentView.addSubview(nameLabel)

		iconView.contentMode = .ScaleAspectFit
		iconView.clipsToBounds = true
		iconView.layer.borderWidth = 2
		iconView.layer.borderColor = UIColor(white: 0.5, alpha: 1).CGColor

		nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		nameLabel.textColor = UIColor.whiteColor()
		nameLabel.textAlignment = .Left
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let bounds = contentView.bounds

		iconView.bounds = CGRect(x: 0, y: 0, width: 42, height: 42)
		iconView.center = CGPoint(x: bounds.minX + 12 + iconView.bounds.width / 2, y: bounds.midY)
		iconView.layer.cornerRadius = 21

		nameLabel.frame = CGRect(x: iconView.frame.maxX + 16, y: 0, width: bounds.width - (iconView.frame.maxX + 16), height: bounds.height)
	}
}

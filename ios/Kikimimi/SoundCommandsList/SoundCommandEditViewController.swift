//
//  SoundCommandEditViewController.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

final class SoundCommandEditViewController: UIViewController {
	var command: Command?

	var recordedFFTData: [FFTData] = []
	var commandCategory: CommandCategory?

	var contentView: UIView!
	var categoryIconMessageLabel: UILabel!
	var categoryIconView: UIImageView!
	var categoryIconButton: UIButton!
	var nameField: UITextField!
	var actionFieldLabel: UILabel!
	var actionField: UITextField!
	var cancelButton: CircleButton!
	var commitButton: CircleButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.blackColor()

		contentView = UIView()
		contentView.bounds = CGRect(x: 0, y: 0, width: 256, height: 280)
		contentView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
		contentView.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]

		categoryIconView = UIImageView()
		categoryIconView.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
		categoryIconView.center = CGPoint(x: contentView.bounds.midX, y: view.bounds.minY + 120 / 2)
		categoryIconView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
		categoryIconView.layer.borderWidth = 5
		categoryIconView.layer.borderColor = UIColor.whiteColor().CGColor
		categoryIconView.layer.cornerRadius = 60
		categoryIconView.clipsToBounds = true
		categoryIconView.image = UIImage(named: CommandCategory.c1.imageName)
		categoryIconView.userInteractionEnabled = false

		categoryIconMessageLabel = UILabel()
		categoryIconMessageLabel.bounds = CGRect(x: 0, y: 0, width: contentView.bounds.midX, height: 30)
		categoryIconMessageLabel.center = categoryIconView.center
		categoryIconMessageLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
		categoryIconMessageLabel.textColor = UIColor(white: 0.3, alpha: 1)
		categoryIconMessageLabel.text = "tap to setting"

		categoryIconButton = UIButton()
		categoryIconButton.frame = categoryIconView.frame
		categoryIconButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
		categoryIconButton.addTarget(self, action: #selector(SoundCommandEditViewController.selectCategory), forControlEvents: .TouchUpInside)

		nameField = UITextField()
		nameField.frame = CGRect(x: 0, y: categoryIconView.frame.maxY + 30, width: contentView.bounds.width, height: 50)
		nameField.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
		nameField.backgroundColor = UIColor.whiteColor()
		nameField.textColor = UIColor.blackColor()
		nameField.textAlignment = .Center
		nameField.placeholder = "名前追加"
		nameField.delegate = self
		nameField.autocorrectionType = .No
		nameField.returnKeyType = .Done
		nameField.clipsToBounds = true
		nameField.layer.cornerRadius = 4

		actionFieldLabel = UILabel()
		actionFieldLabel.frame = CGRect(x: 0, y: nameField.frame.maxY + 30, width: contentView.bounds.width, height: 12)
		actionFieldLabel.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
		actionFieldLabel.textColor = UIColor(white: 1, alpha: 0.5)
		actionFieldLabel.text = "API URL"
		actionFieldLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)

		actionField = UITextField()
		actionField.frame = CGRect(x: 0, y: actionFieldLabel.frame.maxY, width: contentView.bounds.width, height: 26)
		actionField.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
		actionField.textColor = UIColor.whiteColor()
		actionField.placeholder = "http://"
		actionField.delegate = self
		actionField.autocorrectionType = .No
		actionField.keyboardType = .URL
		actionField.returnKeyType = .Done

		let border = UIView()
		border.frame = CGRect(x: 0, y: actionField.frame.maxY, width: actionField.frame.width, height: 1)
		border.backgroundColor = UIColor.whiteColor()
		border.userInteractionEnabled = false
		border.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]

		cancelButton = CircleButton(imageName: "ic_clear_white")
		cancelButton.center = CGPoint(x: view.bounds.midX - 30, y: view.bounds.maxY - 38)
		cancelButton.backgroundColor = UIColor(hue:0.95, saturation:0.94, brightness:0.89, alpha:1)
		cancelButton.addTarget(self, action: #selector(SoundCommandEditViewController.cancel), forControlEvents: .TouchUpInside)

		commitButton = CircleButton(imageName: "btn_ok")
		commitButton.center = CGPoint(x: view.bounds.midX + 30, y: view.bounds.maxY - 38)
		commitButton.backgroundColor = UIColor(hue:0.39, saturation:0.82, brightness:0.84, alpha:1)
		commitButton.addTarget(self, action: #selector(SoundCommandEditViewController.commit), forControlEvents: .TouchUpInside)

		view.addSubview(contentView)
		view.addSubview(cancelButton)
		view.addSubview(commitButton)

		contentView.addSubview(categoryIconMessageLabel)
		contentView.addSubview(categoryIconView)
		contentView.addSubview(categoryIconButton)
		contentView.addSubview(nameField)
		contentView.addSubview(actionFieldLabel)
		contentView.addSubview(actionField)
		contentView.addSubview(border)

		if let command = command {
			categoryIconView.image = UIImage(named: command.category.imageName)
			nameField.text = command.name
			actionField.text = command.action
		}
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		startObservingKeyboardNotifications()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		stopObservingKeyboardNotifications()
	}

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

	private func startObservingKeyboardNotifications() {
		let center = NSNotificationCenter.defaultCenter()
		center.addObserver(self, selector: #selector(SoundCommandEditViewController.handleKeyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
		center.addObserver(self, selector: #selector(SoundCommandEditViewController.handleKeyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}

	private func stopObservingKeyboardNotifications() {
		let center = NSNotificationCenter.defaultCenter()
		center.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}

	func selectCategory() {
		let categoryController = CategorySelectionViewController()
		categoryController.title = "画像を選択"
		categoryController.selectionHandler = { [weak self] category in
			self?.commandCategory = category
			self?.categoryIconView.image = UIImage(named: category.imageName)
			self?.dismissViewControllerAnimated(true, completion: nil)
		}
		if let category = command?.category {
			categoryController.selectedCategory = category
		}

		let navigationController = UINavigationController(rootViewController: categoryController)
		presentViewController(navigationController, animated: true, completion: nil)
	}

	func handleKeyboardWillShowNotification(notification: NSNotification) {
		let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
		let curveValue = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
		let curve = UIViewAnimationOptions(rawValue: curveValue)

		let animations = {
			self.contentView.transform = CGAffineTransformMakeTranslation(0, -100)
		}

		UIView.animateWithDuration(duration, delay: 0, options: [curve], animations: animations, completion: nil)
	}

	func handleKeyboardWillHideNotification(notification: NSNotification) {
		let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
		let curveValue = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
		let curve = UIViewAnimationOptions(rawValue: curveValue)

		let animations = {
			self.contentView.transform = CGAffineTransformIdentity
		}

		UIView.animateWithDuration(duration, delay: 0, options: [curve], animations: animations, completion: nil)
	}

	func cancel() {
		self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}

	func commit() {
		if let command = command {
			let id = command.id
			let name = nameField.text ?? ""
			let action = actionField.text ?? ""
			let category = commandCategory ?? CommandCategory.c1
			let newCommand = Command(id: id, name: name, action: action, category: category)
			FirebaseManager.sharedInstance.updateCommand(newCommand)
		} else {
			let name = nameField.text ?? ""
			let action = actionField.text ?? ""
			let category = commandCategory ?? CommandCategory.c1
			FirebaseManager.sharedInstance.registerCommand(name, action: action, category: category, recordedData: recordedFFTData)
		}

		self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}

}

extension SoundCommandEditViewController: UITextFieldDelegate {
	func textFieldShouldEndEditing(textField: UITextField) -> Bool {
		return true
	}

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}

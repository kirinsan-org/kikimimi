//
//  SoundCommandsListController.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import UIKit

class SoundCommandsListController: UIViewController {

	private var tableView: UITableView!
	private var backButton: CircleButton!
	private var addButton: CircleButton!

	var commands: [Command] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView = UITableView(frame: view.bounds, style: .Plain)
		tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		tableView.backgroundColor = UIColor.blackColor()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.rowHeight = 64
		tableView.separatorInset = UIEdgeInsetsZero
		tableView.separatorColor = UIColor(white: 0.2, alpha: 1)
		tableView.registerClass(SoundCommandCell.self, forCellReuseIdentifier: "Command")

		view.addSubview(tableView)

		addButton = CircleButton(imageName: "ic_add_white")
		addButton.center = CGPoint(x: view.bounds.maxX - (12 + 44 / 2), y: view.bounds.maxY - (12 + 44 / 2))
		addButton.backgroundColor = UIColor(hue:0.04, saturation:0.88, brightness:0.99, alpha:1)
		addButton.addTarget(self, action: #selector(SoundCommandsListController.add), forControlEvents: .TouchUpInside)

		backButton = CircleButton(imageName: "ic_arrow_back_white")
		backButton.center = CGPoint(x: addButton.frame.minX - (8 + 44 / 2), y: addButton.center.y)
		backButton.addTarget(self, action: #selector(SoundCommandsListController.back), forControlEvents: .TouchUpInside)

		view.addSubview(backButton)
		view.addSubview(addButton)

//		FirebaseManager.sharedInstance.observerEvent { [weak self] event in
//			switch event {
//			case .CommandListChanged(let commands):
//				self?.commands = commands
//			default:
//				break
//			}
//		}

		let dummyCommands = [
			Command(id: "dummy1", name: "とてもおいしいモンテール", action: "", category: CommandCategory(rawValue: 1)!),
			Command(id: "dummy2", name: "ヨハネちゃんかわいい", action: "", category: CommandCategory(rawValue: 2)!),
			Command(id: "dummy3", name: "とてもおいしいモンテール", action: "", category: CommandCategory(rawValue: 3)!),
			Command(id: "dummy4", name: "ヨハネちゃんかわいい", action: "", category: CommandCategory(rawValue: 4)!),
			Command(id: "dummy5", name: "とてもおいしいモンテール", action: "", category: CommandCategory(rawValue: 5)!),
			Command(id: "dummy6", name: "ヨハネちゃんかわいい", action: "", category: CommandCategory(rawValue: 6)!),
			Command(id: "dummy7", name: "とてもおいしいモンテール", action: "", category: CommandCategory(rawValue: 7)!),
			Command(id: "dummy8", name: "ヨハネちゃんかわいい", action: "", category: CommandCategory(rawValue: 8)!),
			Command(id: "dummy9", name: "とてもおいしいモンテール", action: "", category: CommandCategory(rawValue: 9)!)
		]
		self.commands = dummyCommands
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

	func back() {
		self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}

	func add() {
		let controller = SoundCommandRecordingViewController()
		navigationController?.pushViewController(controller, animated: true)
	}
	
}

extension SoundCommandsListController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.commands.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Command") as! SoundCommandCell
		let command = commands[indexPath.item]

		cell.nameLabel.text = command.name
		cell.iconView.image = UIImage(named: command.category.imageName)
		cell.iconView.layer.borderColor = UIColor(hue: CGFloat(command.category.rawValue) / 24, saturation: 0.86, brightness: 1, alpha: 1).CGColor

		return cell
	}
}

extension SoundCommandsListController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

	}
}

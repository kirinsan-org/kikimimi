//
//  RootViewController.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/2/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let controller = VisualizerViewController()
		self.presentViewController(controller, animated: false, completion: nil)
	}

}

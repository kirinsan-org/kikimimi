//
//  VisualizerViewController.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import UIKit

protocol VisualizerViewControllerDataSource: class, VisualizerSceneDataSource{
	func getFTTSampleArray() -> [Double]
}

class VisualizerViewController: UIViewController {
	
	private let visualizerView: VisualizerView
	
	private let bubbleColors: [UIColor]
	
	weak var dataSource: VisualizerViewControllerDataSource?
	
	init(visualizerView view: VisualizerView? = nil) {
		
		self.visualizerView = view ?? VisualizerView()
		let colorStrings = ["FF0000","FF0000","FF0000","FF0000","FF0000","FF0000",
		                    "FF0000","FF0000","FF0000","FF0000","FF0000","FF0000",
		                    "FF0000","FF0000","FF0000","FF0000","FF0000","FF0000",
		                    "FF0000","FF0000","FF0000","FF0000","FF0000","FF0000",
		                    "FF0000","FF0000","FF0000","FF0000","FF0000","FF0000",
		                    "FF0000","FF0000"]
		let colors = colorStrings.map { (colorValue) -> UIColor in
			let rgbValue = Int(colorValue, radix: 16) ?? 0
			let rgbaValue = (rgbValue << 8) + 0x7F
			return UIColor(hexRGBAValue: rgbaValue)
		}
		self.bubbleColors = colors
		
		super.init(nibName: nil, bundle: nil)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		visualizerView.frame = UIScreen.mainScreen().bounds
		self.view = visualizerView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		visualizerView.showsFPS = true
		visualizerView.showsNodeCount = true
		
		let scene = VisualizerScene(size: visualizerView.frame.size)
		scene.dataSource = self
		visualizerView.backgroundColor = .whiteColor()
		scene.scaleMode = .AspectFill
		visualizerView.presentScene(scene)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return [.Portrait, .PortraitUpsideDown]
	}
	
}

extension VisualizerViewController: VisualizerSceneDataSource {
	
	func getBubbleSettings() -> [UIColor] {
		return self.bubbleColors
	}
	
}

//
//  VisualizerViewController.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import UIKit

protocol VisualizerViewControllerDataSource: class{
	func getFFTSampleArray() -> [Double]
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

		let commandListButton = CircleButton(imageName: "ic_list_white")
		commandListButton.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
		commandListButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - (13 + 44 / 2))
		commandListButton.addTarget(self, action: #selector(VisualizerViewController.presentCommandList), forControlEvents: .TouchUpInside)
		view.addSubview(commandListButton)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		visualizerView.scene?.paused = false
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		visualizerView.scene?.paused = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return [.Portrait, .PortraitUpsideDown]
	}

	func presentCommandList() {
		let listController = SoundCommandsListController()
		let navigationController = UINavigationController(rootViewController: listController)
		navigationController.navigationBarHidden = true
		presentViewController(navigationController, animated: true, completion: nil)
	}
}

extension VisualizerViewController: VisualizerSceneDataSource {
	
	func getBubbleSettings() -> [UIColor] {
		return self.bubbleColors
	}
	
	func getBubbleScales() -> [CGFloat] {
		guard let array = self.dataSource?.getFFTSampleArray() where array.count >= self.bubbleColors.count else {
			return [CGFloat](count: self.bubbleColors.count, repeatedValue: 0.5)
		}
		
		let fftElementsPerBubble = array.count / self.bubbleColors.count
		let scales = array.enumerate().reduce([]) { (scales, element) -> [Double] in
			var scales = scales
			
			let lastFFTElement: Double
			if element.index % fftElementsPerBubble == 0 {
				lastFFTElement = 0
				
			} else {
				lastFFTElement = scales.last ?? 0
				scales.removeLast()
			}
			
			var newElement = lastFFTElement + element.element
			
			if element.index % fftElementsPerBubble == fftElementsPerBubble.decreased {
//				newElement /= Double(fftElementsPerBubble)
				newElement += 0.5
			}
			
			scales.append(newElement)
			return scales
			
		}
		
		return scales.map({ (scale) -> CGFloat in
			return CGFloat(scale)
		})
		
	}
	
}

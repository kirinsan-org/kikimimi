//
//  VisualizerViewController.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import SpriteKit

protocol VisualizerViewControllerDataSource: class{
	func getFFTSampleArray() -> [Double]
}

class VisualizerViewController: UIViewController {
	
	private let visualizerView: VisualizerView
	
	private let bubbleColors: [(fillColor: UIColor, strokeColor: UIColor)]
	
	weak var dataSource: VisualizerViewControllerDataSource?
	
	init(visualizerView view: VisualizerView? = nil) {
		
		self.visualizerView = view ?? VisualizerView()
		let colorStrings = [
			["ff002a","ff002a"],
			["ff2f00","ff2f00"],
			["ff5e00","ff5e00"],
			["ff8c00","ff8c00"],
			["ffbb00","ffbb00"],
			["ffea00","ffea00"],
			["e5ff00","e5ff00"],
			["b7ff00","b7ff00"],
			["88ff00","88ff00"],
			["59ff00","59ff00"],
			["2bff00","2bff00"],
			["00ff33","00ff33"],
			["00ff62","00ff62"],
			["00ff91","00ff91"],
			["00ffbf","00ffbf"],
			["00ffee","00ffee"],
			["00e1ff","00e1ff"],
			["00b2ff","00b2ff"],
			["0084ff","0084ff"],
			["0055ff","0055ff"],
			["0026ff","0026ff"],
			["0900ff","0900ff"],
			["3700ff","3700ff"],
			["6600ff","6600ff"],
			["9600ff","9600ff"],
			["c400ff","c400ff"],
			["f200ff","f200ff"],
			["ff00dd","ff00dd"],
			["ff00ae","ff00ae"],
			["FF007f","FF007f"],
			["ff0051","ff0051"],
			["FF0000","FF0000"],
		]
		let colors = colorStrings.map { (colorValue) -> (fillColor: UIColor, strokeColor: UIColor) in
			let fillColor, strokeColor: UIColor
			
			do {
				let rgbValue = Int(colorValue[0], radix: 16) ?? 0
				let rgbaValue = (rgbValue << 8) + 0x7F
				fillColor = UIColor(hexRGBAValue: rgbaValue)
			}
			
			do {
				let rgbValue = Int(colorValue[1], radix: 16) ?? 0
				let rgbaValue = (rgbValue << 8) + 0x7F
				strokeColor = UIColor(hexRGBAValue: rgbaValue)
			}
			
			return (fillColor, strokeColor)
			
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
	
	func getBubbleSettings() -> [(fillColor: SKColor, strokeColor: SKColor)] {
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
				newElement /= Double(fftElementsPerBubble)
				newElement *= 4
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

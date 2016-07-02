//
//  VisualizerViewController.swift
//  Kikimimi
//
//  Created by 史翔新 on 2016/07/03.
//  Copyright © 2016年 kirinsan.org. All rights reserved.
//

import UIKit

class VisualizerViewController: UIViewController {
	
	private let visualizerView: VisualizerView
	
	weak var sceneDataSource: VisualizerSceneDataSource?
	
	init(visualizerView view: VisualizerView? = nil) {
		self.visualizerView = view ?? VisualizerView()
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
		visualizerView.backgroundColor = .whiteColor()
		scene.dataSource = self.sceneDataSource
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

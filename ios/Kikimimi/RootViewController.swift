//
//  RootViewController.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/2/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

	private var fftData: FFTData?
	private let visualizerController = VisualizerViewController()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		do {
			let controller = self.visualizerController
			self.addChildViewController(controller)
			self.view.addSubview(controller.view)
			controller.didMoveToParentViewController(self)
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		SoundAnalyzer.sharedInstance.observerEvent { [weak self] event in
			switch event {
				case .Update(_, let fftData, _):
				self?.fftData = fftData
			default:
				break
			}
		}

		FirebaseManager.sharedInstance.observerEvent { event in
			switch event {
			case .DetectedCommandChanged(let command):
				self.visualizerController.fireCommand(command) {
					FirebaseManager.sharedInstance.resetDetectedCommand()
				}
				
			default:
				break
			}
		}
		
	}

//	override func preferredStatusBarStyle() -> UIStatusBarStyle {
//		return .LightContent
//	}

}

extension RootViewController: VisualizerViewControllerDataSource {
	func getFFTSampleArray() -> [Double] {
		return fftData?.values ?? []
	}
}

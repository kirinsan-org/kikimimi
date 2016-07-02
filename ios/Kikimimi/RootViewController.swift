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

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let controller = VisualizerViewController()
		controller.sceneDataSource = self
		self.presentViewController(controller, animated: false, completion: nil)

		SoundAnalyzer.sharedInstance.observerEvent { [weak self] event in
			switch event {
				case .Update(_, let fftData, _):
				self?.fftData = fftData
			default:
				break
			}
		}
	}

}

extension RootViewController: VisualizerSceneDataSource {
	func getFFTSampleArray() -> [Double] {
		return fftData?.values ?? []
	}
}

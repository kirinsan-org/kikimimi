//
//  SoundCommandRecordingViewController.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

final class SoundCommandRecordingViewController: UIViewController {
	var graphView: FFTGraphView!

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		graphView = FFTGraphView(frame: view.bounds)
		graphView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		view.addSubview(graphView)

		SoundAnalyzer.sharedInstance.observerEvent { [graphView] event in
			switch event {
			case .Update(_, let fftData, _):
				graphView.fftData = fftData
			default:
				break
			}
		}
	}
}

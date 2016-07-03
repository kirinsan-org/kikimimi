//
//  SoundCommandRecordingViewController.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import UIKit

final class SoundCommandRecordingViewController: UIViewController {
	enum State {
		case Waiting
		case Recording
		case Done
	}

	private(set) var state: State = .Waiting {
		didSet {
			updateMessage()
			switch state {
			case .Done:
				self.showDoneMark()
			default:
				self.hideDoneMark()
			}
		}
	}

	private var recordedFFTData: [FFTData] = []
	private let recodingSampleCount = 4

	private var circleMaskView: UIView!
	private var progressView: ProgressCircleView!
	private var graphView: FFTGraphView!
	private var messageLabel: UILabel!
	private var doneImageView: UIImageView!
	private var backButton: CircleButton!

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.blackColor()

		circleMaskView = UIView()
		circleMaskView.bounds = CGRect(x: 0, y: 0, width: 240, height: 240)
		circleMaskView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
		circleMaskView.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]
		circleMaskView.clipsToBounds = true
		circleMaskView.layer.cornerRadius = 111
		circleMaskView.layer.borderWidth = 16

		backButton = CircleButton(imageName: "ic_arrow_back_white")
		backButton.center = CGPoint(x: view.bounds.minX + (8 + 44 / 2), y: view.bounds.minY + (20 + 44 / 2))
		backButton.autoresizingMask = [.FlexibleRightMargin, .FlexibleBottomMargin]
		backButton.addTarget(self, action: #selector(SoundCommandRecordingViewController.back), forControlEvents: .TouchUpInside)

		graphView = FFTGraphView(frame: circleMaskView.bounds)
		graphView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

		messageLabel = UILabel(frame: circleMaskView.bounds)
		messageLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		messageLabel.textAlignment = .Center
		messageLabel.textColor = UIColor.whiteColor()
		messageLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		messageLabel.numberOfLines = 0

		doneImageView = UIImageView(image: UIImage(named: "done"))
		doneImageView.center = CGPoint(x: circleMaskView.bounds.midX, y: circleMaskView.bounds.midY)
		doneImageView.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]

		progressView = ProgressCircleView()
		progressView.frame = circleMaskView.frame
		progressView.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleRightMargin]

		view.addSubview(circleMaskView)
		view.addSubview(progressView)
		view.addSubview(backButton)

		circleMaskView.addSubview(graphView)
		circleMaskView.addSubview(messageLabel)
		circleMaskView.addSubview(doneImageView)

		updateMessage()
		hideDoneMark()

		SoundAnalyzer.sharedInstance.observerEvent { [weak self] event in
			guard let s = self else {
				return
			}
			switch event {
			case .Update(_, let fftData, _):
				s.graphView.fftData = fftData
			case .StartRecording:
				s.state = .Recording
			case .StopRecording(let fftData):
				s.recordedFFTData.append(fftData)
				let count = s.recordedFFTData.count
				let maxCount = s.recodingSampleCount
				s.progressView.progress = CGFloat(count) / CGFloat(maxCount)
				if count >= s.recodingSampleCount {
					s.state = .Done
				} else {
					s.state = .Waiting
				}
			}
		}
	}

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

	func back() {
		navigationController?.popViewControllerAnimated(true)
	}

	private func updateMessage() {
		switch state {
		case .Waiting:
			messageLabel.text = "音を鳴らしてください"
		case .Recording:
			messageLabel.text = "聴いています"
		case .Done:
			messageLabel.text = nil
		}
	}

	private func showDoneMark() {
		let view = doneImageView
		view.alpha = 0
		view.transform = CGAffineTransformMakeScale(0.5, 0.5)

		let updates = {
			view.alpha = 1
			view.transform = CGAffineTransformIdentity
		}

		UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.BeginFromCurrentState], animations: updates, completion: nil)
	}

	private func hideDoneMark() {
		let view = doneImageView

		let updates = {
			view.alpha = 0
			view.transform = CGAffineTransformMakeScale(0.5, 0.5)
		}

		UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.BeginFromCurrentState], animations: updates, completion: nil)
	}

}

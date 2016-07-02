//
//  SoundAnalyzer.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/2/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import Foundation
import AudioKit

final class SoundAnalyzer {
	static let sharedInstance = SoundAnalyzer()

	private let mic: AKMicrophone
	private let fft: AKFFTTap
	private let amplitudeTracker: AKAmplitudeTracker

	private var loop: Loop!
	private var lastAmplitude: Double?
	private let amplitudeThreshold: Double = 0.1
	private var recordingFFTData = Array<FFTData>()
	private let recordingDuration: CFTimeInterval = 1
	private var recordingStartTime: CFTimeInterval?

	private(set) var isListening: Bool = false   // マイクから音を拾っているか
	private(set) var isRecording: Bool = false { // (環境音より大きな音をトリガーに) サーバ送信用に音を収集しているか
		didSet {
			print("isRecording: \(isRecording)")
		}
	}

	enum Event {
		// amplitude: 音全体のレベル
		// fftData: 各周波数帯ごとの成分量
		// isCapturing: (環境音より大きな音をトリガーに) 音認識のための音を収集しているか
		case Update(amplitude: Double, fftData: FFTData, isRecording: Bool)
		case StartRecording
		case StopRecording(optimizedFFTData: FFTData)
	}

	typealias EventObserver = (Event) -> Void
	private var eventObservers: [EventObserver] = []

	init() {
		mic = AKMicrophone()
		fft = AKFFTTap(mic)
		amplitudeTracker = AKAmplitudeTracker(mic)

		// Turn the volume all the way down on the output of amplitude tracker
		let noAudioOutput = AKMixer(amplitudeTracker)
		noAudioOutput.volume = 0
		AudioKit.output = noAudioOutput

		loop = Loop(frequency: 44100, handler: { [unowned self] in
			let fftData = FFTData(values: self.fft.fftData)
			let amplitude = self.amplitudeTracker.amplitude
			let currentTime = NSProcessInfo.processInfo().systemUptime

			if self.isRecording {
				self.recordingFFTData.append(fftData)
				if let startTime = self.recordingStartTime where currentTime - startTime > self.recordingDuration {
					let count = 1024
					var averageValues = Array<Double>(count: count, repeatedValue: 0)
					for i in 0..<count {
						let values = self.recordingFFTData.map({ $0.values[i] })
						averageValues[i] = values.reduce(0, combine: { $0 + $1 }) / count
					}
					let optimizedFFTData = FFTData(values: averageValues)
					self.recordingFFTData.removeAll()
					self.isRecording = false
					self.recordingStartTime = nil
					self.triggerEvent(.StopRecording(optimizedFFTData: optimizedFFTData))
				}
			} else {
				if let last = self.lastAmplitude where amplitude - last > self.amplitudeThreshold {
					self.isRecording = true
					self.recordingStartTime = currentTime
					self.triggerEvent(.StartRecording)
				}
			}

			if self.isListening {
				self.triggerEvent(.Update(amplitude: amplitude, fftData: fftData, isRecording: self.isRecording))
			}

			self.lastAmplitude = amplitude
		})
	}

	func startListening() {
		AudioKit.start()
		isListening = true
	}

	func stopListening() {
		isListening = false
		AudioKit.stop()
	}

	func observerEvent(observer: EventObserver) {
		eventObservers.append(observer)
	}

	private func triggerEvent(event: Event) {
		eventObservers.forEach({ $0(event) })
	}
}

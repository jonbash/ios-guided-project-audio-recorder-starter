//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Paul Solt on 10/1/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorderController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
	
	private lazy var timeFormatter: DateComponentsFormatter = {
		let formatting = DateComponentsFormatter()
		formatting.unitsStyle = .positional // 00:00  mm:ss
		// NOTE: DateComponentFormatter is good for minutes/hours/seconds
		// DateComponentsFormatter not good for milliseconds, use DateFormatter instead)
		formatting.zeroFormattingBehavior = .pad
		formatting.allowedUnits = [.minute, .second]
		return formatting
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()

        timeLabel.font = UIFont.monospacedDigitSystemFont(
            ofSize: timeLabel.font.pointSize,
            weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(
            ofSize: timeRemainingLabel.font.pointSize,
            weight: .regular)

        loadAudio()
	}

    // MARK: - Playback APIs

    private var audioPlayer: AVAudioPlayer?
    private var playbackTimer: Timer?

    var isPlaying: Bool { audioPlayer?.isPlaying ?? false }
    var elapsedTime: TimeInterval { audioPlayer?.currentTime ?? 0 }

    @IBAction func playButtonPressed(_ sender: Any) {
        playPause()
	}

    func loadAudio() {
        // piano.mp3
        // app bundle - readonly
        // documents - readwrite
        guard let songURL = Bundle.main.url(
            forResource: "piano",
            withExtension: "mp3")
            else {
                print("no file!")
                return
        }
        audioPlayer = try? AVAudioPlayer(contentsOf: songURL)
        audioPlayer?.delegate = self
        updateViews()
    }

    func play() {
        audioPlayer?.play()
        updateViews()
        startTimer()
    }

    func pause() {
        audioPlayer?.pause()
        updateViews()
        cancelTimer()
    }

    func playPause() {
        isPlaying ? pause() : play()
    }

    // MARK: - Playback Private

    private func startTimer() {
        cancelTimer()
        playbackTimer = Timer.scheduledTimer(
            timeInterval: 0.03,
            target: self,
            selector: #selector(updateTimer(_:)),
            userInfo: nil,
            repeats: true)
    }

    @objc
    private func updateTimer(_ timer: Timer) {
        updateViews()
    }

    private func cancelTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }

    // MARK: - Record APIs
    
    @IBAction func recordButtonPressed(_ sender: Any) {
    
    }

    // MARK: - UI Update

    private func updateViews() {
        playButton.setTitle(isPlaying ? "Pause" : "Play", for: .normal)
        timeLabel.text = timeFormatter.string(from: elapsedTime)
        timeSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
        timeSlider.value = Float(elapsedTime)
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioRecorderController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error { print(error) }
    }
}

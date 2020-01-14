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

    var audioPlayer: AVAudioPlayer?

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

    @IBAction func playButtonPressed(_ sender: Any) {
        playPause()
	}

    var isPlaying: Bool { audioPlayer?.isPlaying ?? false }

    private func loadAudio() {
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
    }

    private func play() {
        audioPlayer?.play()
    }

    private func pause() {
        audioPlayer?.pause()
    }

    private func playPause() {
        isPlaying ? pause() : play()
    }

    // get audio file
    // play
    // pause
    // stop
    // is it playing?
    // timestamp

    // MARK: - Record APIs
    
    @IBAction func recordButtonPressed(_ sender: Any) {
    
    }
}


//
//  MediaViewController.swift
//  VideoRecorder
//
//  Created by 신병기 on 2022/10/14.
//

import UIKit
import AVFoundation
import AVKit

class MediaViewController: UIViewController {
    static var identifier: String { String(describing: self) }
    
    @IBOutlet weak var mediaView: MediaView!
    @IBOutlet weak var controlView: UIView!
    
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var elapsedLengthLabel: UILabel!
    @IBOutlet weak var totalLengthLabel: UILabel!
    
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    private var isPlaying: Bool = false
    var observer: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
    }
    
    func setupData() {
        // TODO:
        let fileName = "file:///var/mobile/Media/DCIM/100APPLE/IMG_0387.MP4"
        guard let fileURL = URL(string: fileName) else { return }
        self.mediaView.player = AVPlayer(url: fileURL)
        
        self.elapsedLengthLabel.text = "00:00"
        //self.totalLengthLabel.text
        
        // TODO:
        self.slider.maximumValue = 4
    }
    
    func setupUI() {
        self.controlView.layer.cornerRadius = 25
        
        mediaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapViewHandler)))
        
        slider.addTarget(self, action: #selector(didChangeSliderHandler), for: .valueChanged)
        
        [backwardButton, playButton, shareButton].forEach {
            $0?.addTarget(self, action: #selector(didTapButtonHandler(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - 뷰 탭 핸들러
    @objc func didTapViewHandler(_ sender: UIView) {
        controlView.isHidden = !controlView.isHidden
    }
    
    // MARK: - 슬라이더 핸들러
    @objc func didChangeSliderHandler(_ sender: UIView) {
        self.mediaView.player?.currentItem?.seek(to: CMTime(value: CMTimeValue(self.slider.value), timescale: 1, flags: CMTimeFlags(rawValue: 1), epoch: 0)) { _ in
            
        }
    }
    
    // MARK: - 버튼 탭 핸들러
    @objc func didTapButtonHandler(_ sender: UIButton) {
        switch sender {
        case backwardButton:
            resetVideo()
        case playButton:
            if self.isPlaying {
                pauseVideo()
            } else {
                playVideo()
            }
        case shareButton:
            return
        default:
            return
        }
    }
    
    func resetVideo() {
        pauseVideo()
        self.slider.value = 0.0
        self.elapsedLengthLabel.text = "00:00"
        self.mediaView.player?.currentItem?.seek(to: CMTime(seconds: .zero, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) { _ in
            
        }
    }
    
    func playVideo() {
        self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        self.isPlaying = true
        self.mediaView.player?.play()
        
        self.observer = self.mediaView.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main, using: {
            [weak self] time in
            print(#function, time)
            let eplasedTime = time.seconds
            let eplasedTimeInt = Int(eplasedTime)
            let minutes = String(format: "%02d", eplasedTimeInt / 60)
            let seconds = String(format: "%02d", eplasedTimeInt % 60)
            self?.elapsedLengthLabel.text = "\(minutes):\(seconds)"
            self?.slider.value = Float(eplasedTime)
            
            if time.timescale == 600 {
                self?.pauseVideo()
            }
        })
    }
    
    func pauseVideo() {
        self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        self.isPlaying = false
        self.mediaView.player?.pause()
        
        if let observer = self.observer {
            self.mediaView.player?.removeTimeObserver(observer)
            self.observer = nil
        }
    }
}

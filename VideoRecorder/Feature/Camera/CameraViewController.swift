//
//  CameraViewController.swift
//  VideoRecorder
//
//  Created by 신병기 on 2022/10/11.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    static var identifier: String { String(describing: self) }

    @IBOutlet weak var previewView: PreviewView!
    
    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupCaptureSession()
        setupUI()
    }
    
    func setupUI() {
        self.controlView.layer.cornerRadius = 25
        
        self.closeButton.addTarget(self, action: #selector(didTapButtonHandler(_:)), for: .touchUpInside)
        
        self.previewView.videoPreviewLayer.session = self.captureSession
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    // 비디오 인풋과 아웃풋 설정
    func setupCaptureSession() {
        self.captureSession.sessionPreset = .high
        self.captureSession.beginConfiguration()
        
        let videoDevice = getVideoDevice()
        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              self.captureSession.canAddInput(videoInput) else { return }
        self.captureSession.addInput(videoInput)
        
        let videoOutput = AVCaptureMovieFileOutput()
        guard self.captureSession.canAddOutput(videoOutput) else { return }
        self.captureSession.addOutput(videoOutput)
        
        self.captureSession.commitConfiguration()
    }
    
    // 사용 가능한 카메라 타입 획득
    func getVideoDevice() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device.")
        }
    }
    
    @objc func didTapButtonHandler(_ sender: UIButton) {
        switch sender {
        case closeButton:
            self.dismiss(animated: true) {
                self.captureSession.stopRunning()
            }
        default:
            // TODO:
            return
        }
    }
}

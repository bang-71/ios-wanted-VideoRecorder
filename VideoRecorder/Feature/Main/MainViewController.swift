//
//  MainViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    var dataArry : [VideoModel] = [.init(videoImage: UIImage(named: ""), videoName: "Nature.mp4"),
        .init(videoImage: UIImage(named: ""), videoName: "Food.mp4"),
                                   .init(videoImage: UIImage(named: ""), videoName: "Building.mp4"),
                                   .init(videoImage: UIImage(named: ""), videoName: "Concert.mp4"),
                                   .init(videoImage: UIImage(named: ""), videoName: "sfdsfdsfsdf"),
                                   .init(videoImage: UIImage(named: ""), videoName: "ddddddd"),
                                   .init(videoImage: UIImage(named: ""), videoName: "ddddddd"),
                                   .init(videoImage: UIImage(named: ""), videoName: "sfdndlsajkbdsabdjsadjsbadkjsajkdbsakbdsjkabduwqbdjx4sabdksfsdfsd"),
                                   .init(videoImage: UIImage(named: ""), videoName: "sfsdfdshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadsf"),
                                   .init(videoImage: UIImage(named: ""), videoName: "sdfsdaddsjgasdksahjdkjsahdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadsadsdfsd"),
    ]
    
    let navibar: UIButton = {
        let navibar = UIButton()
        navibar.image(for: .normal)
        return navibar
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Video List"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return titleLabel
    }()
    
    @IBOutlet weak var naviBarList: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBarList.tintColor = .black
    }

    @IBAction func didTapCameraButton(_ sender: UIBarButtonItem) {
        checkAuthorization()
    }
    
    // 카메라 권한 확인
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.presentCameraViewController()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.presentCameraViewController()
                }
            }
        case .denied:
            return
        case .restricted:
            return
        @unknown default:
            return
        }
    }
    
    // 카메라 뷰 컨트롤러로 이동
    func presentCameraViewController() {
        DispatchQueue.main.async {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: CameraViewController.identifier) else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell else {return UITableViewCell()}
        
        cell.model = dataArry[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            //백업된영상도 삭제해야하는코드추가해야함
            self.dataArry.remove(at: indexPath.row)
            tableView.reloadData()
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//
//  MainViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import AVFoundation
import Photos

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataArry : [VideoModel] = []
//        .init(videoImage: UIImage(named: ""), videoName: "Nature.mp4"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "Food.mp4"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "Building.mp4"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "Concert.mp4"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "sfdsfdsfsdf"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "ddddddd"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "ddddddd"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "sfdndlsajkbdsabdjsadjsbadkjsajkdbsakbdsjkabduwqbdjx4sabdksfsdfsd"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "sfsdfdshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadsf"),
//                                   .init(videoImage: UIImage(named: ""), videoName: "sdfsdaddsjgasdksahjdkjsahdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadshdksabdkjsadbgasdjksadsadsadsdfsd"), ]
    
        weak var photo: UIImageView!
        var allPhotos: PHFetchResult<PHAsset>? = nil
        //요청하기
        func request() {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        self.retrieveAsset()
                    }
                }
            }
        //에셋에서 이미지 가져오기
        func assetToImage(asset: PHAsset) -> UIImage {
                var image = UIImage()
                let manager = PHImageManager.default()
    
                manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil, resultHandler: {(result, info)->Void in
                    image = result!
                })
                return image
            }
        func retrieveAsset() {
                let fetchOptions = PHFetchOptions()
            allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                let image = assetToImage(asset: (allPhotos?.object(at: 0))!)
    
//                DispatchQueue.main.async {
                    self.dataArry.append(.init(videoImage: image, videoName: "dd"))
//                    self.photo.image = image
//                }
            }
    
    var fetchResult : PHFetchResult<PHAsset>!
    let imageManager : PHCachingImageManager = PHCachingImageManager()
    func requestColltion() {
        let cameraRoll : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
    
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
        self.request()
        //        self.allPhotos = PHAsset.fetchAssets(with: nil)
        let photo_aurthorization_status = PHPhotoLibrary.authorizationStatus()
        switch photo_aurthorization_status {
        case .authorized :
            print("접근 허가됨")
            self.requestColltion()
        case .denied :
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({(status) in
                switch status{
                case .authorized:
                    print("사용자가 허용함")
                    self.requestColltion()
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                case .denied:
                    print("사용자가 불허함")
                default : break
                }
            })
        case .restricted:
            print("접근 제한")
        case .limited:
            print("dd")
        @unknown default:
            print("ddqq22")
        }
        PHPhotoLibrary.shared().register(self)
        
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
//테이블뷰 설정
extension MainViewController: UITableViewDelegate, UITableViewDataSource,PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
        else { return }
        fetchResult = changes.fetchResultAfterChanges
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell else {return UITableViewCell()}
        
        let asset : PHAsset = fetchResult.object(at: indexPath.row)
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFill, options: nil, resultHandler: {image, _ in cell.videoImage.image = image})
    
        cell.videoName.text = asset.localIdentifier
        
        //        cell.model = dataArry[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    
    {
        print("시스템 : \(editingStyle)")
        if editingStyle == .delete
        {
            let asset : PHAsset = self.fetchResult[indexPath.row]
            PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([asset] as NSArray)}, completionHandler: nil)
        }
        print("시스템 : editingStyle", #function)
    }
   func photoLibraryDidChange1(_ changeInstance: PHChange) {
        print("시스템 : ",#function)
        guard let changes = changeInstance.changeDetails(for: fetchResult)
        else { return }
        fetchResult = changes.fetchResultAfterChanges
        OperationQueue.main.addOperation
        {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
    
    
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
    //            //백업된영상도 삭제해야하는코드추가해야함
    //            self.dataArry.remove(at: indexPath.row)
    //            tableView.reloadData()
    //        }
    //        deleteAction.backgroundColor = .systemRed
    //        return UISwipeActionsConfiguration(actions: [deleteAction])
    //    }
}

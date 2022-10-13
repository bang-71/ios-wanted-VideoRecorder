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
    let dateFormatter = DateFormatter()
   
//
    var dataArry : [VideoModel] = []
    
//            weak var photo: UIImageView!
//            var allPhotos: PHFetchResult<PHAsset>? = nil
//            //요청하기
//            func request() {
//                    PHPhotoLibrary.requestAuthorization { (status) in
//                        if status == .authorized {
//                            self.retrieveAsset()
//                        }
//                    }
//                }
//            //에셋에서 이미지 가져오기
//            func assetToImage(asset: PHAsset) -> UIImage {
//                    var image = UIImage()
//                    let manager = PHImageManager.default()
//
//                    manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil, resultHandler: {(result, info)->Void in
//                        image = result!
//                    })
//                    return image
//                }
//            func retrieveAsset() {
//                    let fetchOptions = PHFetchOptions()
//                allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//                    let image = assetToImage(asset: (allPhotos?.object(at: 0))!)
//
//                    DispatchQueue.main.async {
//                        self.dataArry.append(.init(videoImage: image, videoName: "dd"))
////                        self.photo.image = image
//                    }
//                }
//
    var fetchResult : PHFetchResult<PHAsset>!
    let imageManager : PHCachingImageManager = PHCachingImageManager()
    
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
        photoAurthorizationStatus()
//        retrieveAsset()
        //        self.allPhotos = PHAsset.fetchAssets(with: nil)
    }
    
    func requestColltion() {
        let cameraRoll : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        let fetchOptions = PHFetchOptions()
        //생성날짜??
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
    
    
    func photoAurthorizationStatus() {
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
        default : break
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
    //테이블셀은 몇개?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    //테이블셀안의 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as? VideoTableViewCell else {return UITableViewCell()}
        
        let asset : PHAsset = fetchResult.object(at: indexPath.row)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit , options: nil, resultHandler: {image, _ in cell.videoImage.image = image})
        
        cell.videoName.text = "\(asset.localIdentifier)"
        print("에셋 이름은:\(fetchResult[indexPath.row])")
        //에셋 동영상 날짜 포멧
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cell.currentDate.text = dateFormatter.string(from: asset.creationDate ?? Date())
        
        return cell
    }
    //셀 동적높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //스와이프로삭제버튼
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
    //삭제시 테이블셀 정렬
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("시스템 : ",#function)
        guard let changes = changeInstance.changeDetails(for: fetchResult)
        else { return }
        fetchResult = changes.fetchResultAfterChanges
        OperationQueue.main.addOperation
        {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("세번째화면")
//        let vc = ??
        let data = fetchResult[indexPath.row]
//        vc.pageTypeName = .view
//        vc.measureData = data
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

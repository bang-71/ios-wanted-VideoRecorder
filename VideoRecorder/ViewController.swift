//
//  ViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

class ViewController: UIViewController {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBarList.tintColor = .black
    
        
    }
    
    @IBOutlet weak var naviBarList: UIBarButtonItem!
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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


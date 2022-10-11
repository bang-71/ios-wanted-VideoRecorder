//
//  VideoTableViewCell.swift
//  VideoRecorder
//
//  Created by so on 2022/10/11.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    
    
    
    var model: VideoModel? {
        didSet {
            guard let model else {return}
            videoImage.image = model.videoImage
            videoName.text = model.videoName
            currentDate.text = model.currentDate
        }
    }
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoImage.backgroundColor = .gray
        videoImage.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


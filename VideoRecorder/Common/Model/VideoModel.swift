//
//  Model.swift
//  VideoRecorder
//
//  Created by so on 2022/10/11.
//

import Foundation
import UIKit

struct VideoModel {
    var videoImage: UIImage?
    var videoName: String
    var currentDate: String{
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }
    
    init(videoImage: UIImage?, videoName: String ) {
        self.videoImage = videoImage
        self.videoName = videoName
        
        
    }
}

//
//  Model.swift
//  VideoRecorder
//
//  Created by so on 2022/10/11.
//

import Foundation
import UIKit

struct VideoModel {
    var totalLength: Int?
    var totalLengthString: String?
    var fileURL: URL?
    
    init(totalLength: Int? = nil, totalLengthString: String? = nil, fileURL: URL? = nil) {
        self.totalLength = totalLength
        self.totalLengthString = totalLengthString
        self.fileURL = fileURL
    }
}

//
//  Video.swift
//
//  Created by Dilawer Hussain on 12/10/20.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

import UIKit

let kvideo_name = "video_name"
let kvideo_link = "video_link"
let kvideo_is_selected = "video_is_selected"

class Video{

    var videoId: String
    var video_name: String
    var video_link : String
    var video_is_selected: String
    var created_at: String
    var updated_at: String
    
    // MARK: init methods
    init() {
        self.videoId = ""
        self.video_name = ""
        self.video_link = ""
        self.video_is_selected = ""
        self.created_at = ""
        self.updated_at = ""
        
    }
    
    func setVideoData(data : NSDictionary) {
        self.videoId = "\(data[kId] ?? "")"
        self.video_name = data[kvideo_name] as? String ?? ""
        self.video_link = "\(data[kvideo_link] ?? "")"
        self.video_is_selected = "\(data[video_is_selected] ?? "")"
        self.created_at = data[kcreated_at] as? String ?? ""
        self.updated_at = data[updated_at] as? String ?? ""
    }
}


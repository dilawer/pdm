//
//  Episode.swift
//
//  Created by Dilawer Hussain on 12/10/20.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

import UIKit

let kepisode_name = "episode_name"
let kpodcast_name = "podcast_name"
let kduration = "episode_duration"
let kicon = "podcast_icon"
let kauthor = "episode_author"
let kfile_link = "episode_file_link"
let kepisode_description = "episode_description"



class Episode{

    var episodeID: String
    var eposide_name: String
    var podcast_name: String
    var podcast_id:Int
    var author: String
    var file_link: String
    var description: String
    var duration : String
    var icon: String
    
    // MARK: init methods
    init() {
        self.episodeID = ""
        self.eposide_name = ""
        self.podcast_name = ""
        self.author = ""
        self.file_link = ""
        self.description = ""
        self.duration = ""
        self.icon = ""
        self.podcast_id = 0
    }
    
    func setEpisodeData(data : NSDictionary) {
        self.podcast_id = data["podcast_id"] as? Int ?? 0
        self.episodeID = "\(data[kepisode_id] ?? "")"
        self.eposide_name = data[kepisode_name] as? String ?? ""
        self.podcast_name = data[kpodcast_name] as? String ?? ""
        self.author = data[kauthor] as? String ?? ""
        self.file_link = data[kfile_link] as? String ?? ""
        self.description = data[kdescription] as? String ?? ""
        self.duration = "\(data[kduration] ?? "")"
        self.icon = "\(data[kicon] ?? "")"
    }
}


//
//  Episode.swift
//
//  Created by Dilawer Hussain on 12/10/20.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

import UIKit

let kepisode_name = "name"
let kduration = "duration"
let kicon = "icon"

class Episode{

    var episodeID: String
    var eposide_name: String
    var duration : String
    var icon: String
    
    // MARK: init methods
    init() {
        self.episodeID = ""
        self.eposide_name = ""
        self.duration = ""
        self.icon = ""
    }
    
    func setEpisodeData(data : NSDictionary) {
        self.episodeID = "\(data[kId] ?? "")"
        self.eposide_name = data[kepisode_name] as? String ?? ""
        self.duration = "\(data[kduration] ?? "")"
        self.icon = "\(data[kicon] ?? "")"
    }
}


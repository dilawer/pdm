//
//  UserInfo.swift
//
//  Created by Dilawer Hussain on 12/10/20.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

import UIKit


let kuser_id = "user_id"
let kcategory_id = "category_id"
let kpodcast_of_the_week = "podcast_of_the_week"
let kpodcast_is_featured = "podcast_is_featured"
let kpodcast_icon = "podcast_icon"
let kadmin_approval = "admin_approval"
let kuser_cover_image = "user_cover_image"

let kpodcast_description = "podcast_description"

class Podcast{

var podcastID: String
var podcast_name: String
var user_id : String
var category_id: String
    var podcast_of_the_week: String
    var podcast_is_featured: String
    var podcast_icon: String
    var created_at: String
    var updated_at: String
    var podcast_description: String
    var user_cover_image: String
    var admin_approval: Int
    
    // MARK: init methods
    init() {
        self.podcastID = ""
        self.podcast_name = ""
        self.user_id = ""
        self.category_id = ""
        self.podcast_of_the_week = ""
        self.podcast_is_featured = ""
        self.podcast_icon = ""
        self.created_at = ""
        self.updated_at = ""
        self.podcast_description = ""
        self.user_cover_image = ""
        self.admin_approval = 0
        
    }
    
    func setPodcastData(data : NSDictionary) {
        self.podcastID = "\(data[kId] ?? "")"
        self.podcast_name = data[kpodcast_name] as? String ?? ""
        self.user_id = "\(data[kuser_id] ?? "")"
        self.category_id = "\(data[kcategory_id] ?? "")"
        self.podcast_of_the_week = "\(data[kpodcast_of_the_week] ?? "")"
        self.podcast_is_featured = "\(data[kpodcast_is_featured] ?? "")"
        self.podcast_icon = data[kpodcast_icon] as? String ?? ""
        self.created_at = data[kcreated_at] as? String ?? ""
        self.updated_at = data[kupdated_at] as? String ?? ""
        self.podcast_name = data[kpodcast_name] as? String ?? ""
        self.user_cover_image = data[kuser_cover_image] as? String ?? ""
        self.podcast_description = data[kpodcast_description] as? String ?? ""
        self.admin_approval = data[kadmin_approval] as? Int ?? 0
    }
}


//
//  Global.swift
//  pdm
//
//  Created by Muhammad Aqeel on 22/12/2020.
//

import Foundation
import UIKit

class Global {
    class var shared : Global {
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    var clientID = "70556599340-smobq3k4nf9q187oh6pbar14fmji6ddd.apps.googleusercontent.com"
    var imageUrl = "https://pod-digital-media-bucket.s3.us-east-2.amazonaws.com/category_icon/"
    var universalPlayer:UniversalPlayer?
    var podcaste:Pod?
    var podDetails:DetailsDataClass?
    var nowPlayingPodDetails:DetailsDataClass?
    var curentPlayingID = ""
    var currentPlayingIndex = 0
    var likedPodcast = [String]()
    var userPodcastID:String?
    var userPodcastImageLink:String = ""
    var userPodcastName = ""
    var userPodcastCategory = ""
    var activeViewController = UIViewController()
    
    var Home:HomeViewController?
    var podCastOfTheWeek:Podcast!
    
    func showPlayer(frame:CGRect) -> UniversalPlayer{
        let alert = UniversalPlayer.instanceFromNib()
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        alert.frame = frame
        currentWindow?.addSubview(alert)
        return alert
    }
    func isLiked(id:String) -> Bool{
        for i in likedPodcast{
            if id == i{
                return true
            }
        }
        return false
    }
}

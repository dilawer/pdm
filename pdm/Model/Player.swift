//
//  Player.swift
//  pdm
//
//  Created by Muhammad Aqeel on 28/12/2020.
//

import Foundation
import UIKit

struct Player {
    var image:UIImage?
    var podcastName:String?
    var episodeName:String?
    var isPlaying = false
    var currentEpisode:Episode?
    var currentPodcast:Podcast?
}

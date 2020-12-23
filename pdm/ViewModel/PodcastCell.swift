//
//  PodcastCell.swift
//  pdm
//
//  Created by Muhammad Aqeel on 23/12/2020.
//

import UIKit

class PodcastCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet weak var ivImage: UIImageViewX!
    @IBOutlet weak var lblPodcastName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblEpisodeName: UILabel!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(podcast:Podcasts,width:CGFloat){
        ImageLoader.loadImage(imageView: ivImage, url: podcast.podcastIcon)
        lblPodcastName.text = podcast.podcastName
        lblDuration.text = podcast.podcastDuration
        lblEpisodeName.text = podcast.podcastDuration
        self.width.constant = width
    }
}

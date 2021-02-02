//
//  UniversalPlayer.swift
//  pdm
//
//  Created by Muhammad Aqeel on 28/12/2020.
//

import UIKit
import Alamofire

class UniversalPlayer: UIView {
    
    //MARK:- Outlets
    @IBOutlet weak var ivImage: UIImageViewX!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var ivLike: UIImageView!
    @IBOutlet weak var ivPlay: UIImageView!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    //MARK:- Actions
    @IBAction func actionLike(_ sender: Any) {
        isLiked = !isLiked
        var status = "0"
        if isLiked{
            status = "1"
        }
        WebManager.getInstance(delegate: self)?.LikePodcast(parms: ["podcast_id":Global.shared.curentPlayingID,"liked_status":status])
    }
    @IBAction func actionPrevious(_ sender: Any) {
        MusicPlayer.instance.slowForward()
    }
    @IBAction func actionNext(_ sender: Any) {
        MusicPlayer.instance.fastForward()
    }
    @IBAction func actionPlayPause(_ sender: Any) {
        if MusicPlayer.instance.isPlaying{
            MusicPlayer.instance.pause()
        } else {
            MusicPlayer.instance.play()
        }
    }
    @IBAction func actionOpenDetails(_ sender: Any) {
        let vc = activeViewController.storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController
        vc?.podCastID = Global.shared.curentPlayingID
        vc?.episodeID = Global.shared.podcaste?.episodeID
        vc?.fromMin = true
        activeViewController.navigationController?.pushViewController(vc!, animated: true)
    }
    
    class func instanceFromNib() -> UniversalPlayer {
        let view = UINib(nibName: "UniversalPlayer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UniversalPlayer
        if let pod = Global.shared.podcaste{
            ImageLoader.loadImage(imageView: view.ivImage, url: Global.shared.nowPlayingPodDetails?.podcastIcon ?? "")
            view.lblName.text = Global.shared.nowPlayingPodDetails?.podcastName
            view.lblEpisode.text = pod.episodeName
            if MusicPlayer.instance.isPlaying {
                view.ivPlay.image = UIImage(named: "ic_ipause")
                view.rightConstraint.constant = 8
            } else {
                view.ivPlay.image = UIImage(named: "ic_iplay")
                view.rightConstraint.constant = 4
            }
        }
        view.refresh()
        return view
    }
    var isLiked = false{
        didSet{
            if isLiked{
                ivLike.image = UIImage(named: "ic_liked")
            } else {
                ivLike.image = UIImage(named: "ic_unLiked")
            }
        }
    }
    var activeViewController = UIViewController()
}

//MARK:- Music Player
extension UniversalPlayer:MusicDelgate{
    func playerStausChanged(isPlaying: Bool) {
        if isPlaying {
            self.ivPlay.image = UIImage(named: "ic_ipause")
            self.rightConstraint.constant = 8
        } else {
            self.ivPlay.image = UIImage(named: "ic_iplay")
            self.rightConstraint.constant = 4
        }
    }
    
    func songChanged(pod: Pod) {
        if let pod = Global.shared.podcaste{
            ImageLoader.loadImage(imageView: self.ivImage, url: pod.podcast_icon ?? "")
            self.lblName.text = pod.podcast_name
            self.lblEpisode.text = pod.episodeName
            if MusicPlayer.instance.isPlaying {
                self.ivPlay.image = UIImage(named: "ic_ipause")
            } else {
                self.ivPlay.image = UIImage(named: "ic_iplay")
            }
        }
    }
    func refresh(){
        if let pod = Global.shared.podcaste{
            if let view = Global.shared.universalPlayer{
                ImageLoader.loadImage(imageView: view.ivImage, url: Global.shared.nowPlayingPodDetails?.podcastIcon ?? "")
                view.lblName.text = Global.shared.nowPlayingPodDetails?.podcastName
                view.lblEpisode.text = pod.episodeName
                if MusicPlayer.instance.isPlaying {
                    view.ivPlay.image = UIImage(named: "ic_ipause")
                    view.rightConstraint.constant = 8
                } else {
                    view.ivPlay.image = UIImage(named: "ic_iplay")
                    view.rightConstraint.constant = 4
                }
            }
        }
        if Global.shared.isLiked(id: Global.shared.curentPlayingID){
            isLiked = true
            ivLike.image = UIImage(named: "ic_liked")
        } else {
            isLiked = false
            ivLike.image = UIImage(named: "ic_unLiked")
        }
    }
}

//MARK:- Api
extension UniversalPlayer:WebManagerDelegate{
    func failureResponse(response: AFDataResponse<Any>) {
    }
    
    func networkFailureAction() {
    }
    
    func successResponse(response: AFDataResponse<Any> ,webManager: WebManager) {
        switch(response.result) {
        case .success(let JSON):
            if let result = JSON as? NSDictionary{
                if let successresponse = result.object(forKey: "success"){
                    if(successresponse as! Bool == false) {
                    } else {
                        do {
                            if let msg = result.object(forKey: "message") as? String{
                                if msg.contains("unliked successfully"){
                                    for (index,i) in Global.shared.likedPodcast.enumerated().reversed(){
                                        if i == Global.shared.curentPlayingID{
                                            Global.shared.likedPodcast.remove(at: index)
                                        }
                                    }
                                }else if msg.contains("liked successfully"){
                                    Global.shared.likedPodcast.append(Global.shared.curentPlayingID)
                                }
                            }
                            Global.shared.universalPlayer?.refresh()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            break
        case .failure(_):
            break
        }
    }
}

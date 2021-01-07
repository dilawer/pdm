//
//  LipServiceViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 18/10/2020.
//

import UIKit
import Alamofire
import AVFoundation

class LipServiceViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    //MARK:- Outlets
    @IBOutlet weak var lipServiceCollectionView: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblProgressView: UIProgressView!
    @IBOutlet weak var ivPodcast: UIImageView!
    
    @IBOutlet weak var lblPlayPause: UIButton!
    @IBOutlet weak var ivNextEpisode: UIImageView!
    @IBOutlet weak var lblNextName: UILabel!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var btnShufffle: UIButton!
    @IBOutlet weak var btnFastForward: UIButton!
    @IBOutlet weak var ivPlayPause: UIImageView!
    @IBOutlet weak var ivLike: UIImageView!
    
    //MARK:- Actions
    @IBAction func actionPlayPause(_ sender: Any) {
        if shouldPlay{
            if let active = activePod{
                Global.shared.podcaste = active
                Global.shared.curentPlayingID = podCastID
                ivPlayPause.image = UIImage(named: "ic_ipause")
                MusicPlayer.instance.initPlayer(url: active.episodeFileLink)
                MusicPlayer.instance.play()
                MusicPlayer.instance.progressBar = lblProgressView
                WebManager.getInstance(delegate: self)?.PlayPodCast(parms: ["podcast_id":podCastID,
                                                                            "episode_id":String(active.episodeID)])
                shouldPlay = false
            }
        }
        else {
            let music = MusicPlayer.instance
            let isPlaying = music.player.isPlaying
            if isPlaying{
                music.pause()
                ivPlayPause.image = UIImage(named: "ic_iplay")
            }else{
                music.play()
                ivPlayPause.image = UIImage(named: "ic_ipause")
            }
        }
    }
    @IBAction func actionRepeat(_ sender: Any) {
        MusicPlayer.instance.didRepeat = !MusicPlayer.instance.didRepeat
        refreshUI()
    }
    @IBAction func actionBack(_ sender: Any) {
        MusicPlayer.instance.slowForward()
    }
    @IBAction func actionShuffle(_ sender: Any) {
        MusicPlayer.instance.didShuffle = !MusicPlayer.instance.didShuffle
        refreshUI()
    }
    @IBAction func actionFastForward(_ sender: Any) {
        MusicPlayer.instance.fastForward()
    }
    @IBAction func actionLike(_ sender: Any) {
        var status = "0"
        isLiked = !isLiked
        if isLiked{
            status = "1"
        }
        WebManager.getInstance(delegate: self)?.LikePodcast(parms: ["podcast_id":podCastID,"liked_status":status])
    }
    @IBAction func actionNext(_ sender: Any) {
        if let globalList = Global.shared.podDetails{
            if globalList.pods.count > Global.shared.currentPlayingIndex+1{
                Global.shared.currentPlayingIndex += 1
                let new = globalList.pods[Global.shared.currentPlayingIndex]
                MusicPlayer.instance.pause()
                MusicPlayer.instance.stop()
                MusicPlayer.instance.initPlayer(url: new.episodeFileLink)
                Global.shared.podcaste = new
                MusicPlayer.instance.delegate?.songChanged(pod: new)
                if globalList.pods.count > Global.shared.currentPlayingIndex+1{
                    let next = globalList.pods[Global.shared.currentPlayingIndex+1]
//                    ImageLoader.loadImage(imageView: ivNextEpisode, url: next.podcast_icon ?? "")
                    lblNextName.text = next.episodeName
                } else {
                    ivNextEpisode.image = nil
                    lblNextName.text = "-"
                }
            } else {
                Utility.showAlertWithSingleOption(controller: self, title: "No More Episode", message: "This is Your Last Episode of \(globalList.podcastName)", preferredStyle: .alert, buttonText: "OK")
            }
        }
    }
    
    //MARK:- Variables
    var profiletitleArr = [String]()
    var profilesubtitleArr = [String]()
    var profiletimeArr = [String]()
    var profileimageArr = [String]()
    var moreArray = [Podcasts]()
    var activePod:Pod?
    var shouldPlay = true
    var found = false
    var isLiked = false{
        didSet{
            if isLiked{
                ivLike.image = UIImage(named: "ic_liked")
            } else {
                ivLike.image = UIImage(named: "ic_unLiked")
            }
        }
    }
    var podCastID = "1"
    var episodeID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemSize = UIScreen.main.bounds.width/3 - 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 40, height: itemSize + 40)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 15
        lipServiceCollectionView.collectionViewLayout = layout
        MusicPlayer.instance.delegate = self
        WebManager.getInstance(delegate: self)?.getPodcastDetails(podCast_id: podCastID)
        register()
    }
    override func viewDidAppear(_ animated: Bool) {
        let music = MusicPlayer.instance
        let isPlaying = music.player.isPlaying
        if Global.shared.curentPlayingID == podCastID{
            if isPlaying{
                MusicPlayer.instance.progressBar = lblProgressView
                ivPlayPause.image = UIImage(named: "ic_ipause")
                shouldPlay = false
            }
        } else {
            shouldPlay = true
        }
        if Global.shared.isLiked(id: podCastID){
            isLiked = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        Global.shared.universalPlayer?.alpha = 0
        refreshUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        Global.shared.universalPlayer?.alpha = 1
    }
    func refreshUI(){
        if MusicPlayer.instance.didRepeat{
            btnRepeat.setBackgroundImage(UIImage(named: "ic_loop_selected"), for: .normal)
        } else {
            btnRepeat.setBackgroundImage(UIImage(named: "ic_repeat"), for: .normal)
        }
        if MusicPlayer.instance.didShuffle{
            btnShufffle.setBackgroundImage(UIImage(named: "ic_shuffle_selected"), for: .normal)
        } else {
            btnShufffle.setBackgroundImage(UIImage(named: "ic_shuffl"), for: .normal)
        }
    }
}

//MARK:- Collection
extension LipServiceViewController{
    func register(){
        lipServiceCollectionView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        shouldPlay = true
        MusicPlayer.instance.stop()
        lblProgressView.progress = 0.0
        ivPlayPause.image = UIImage(named: "ic_iplay")
        podCastID = String(moreArray[indexPath.row].podcastID)
        Global.shared.curentPlayingID = podCastID
        WebManager.getInstance(delegate: self)?.getPodcastDetails(podCast_id: podCastID)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        let cellIndex = indexPath.row
        
        cell.config(podcast: moreArray[cellIndex], width: (self.lipServiceCollectionView.frame.width / 2)-20)
        return cell
    }
}

//MARK:- Api
extension LipServiceViewController:WebManagerDelegate{
    func failureResponse(response: AFDataResponse<Any>) {
        Utility.showAlertWithSingleOption(controller: self, title: kEmpty, message: kCannotConnect, preferredStyle: .alert, buttonText: kok, buttonHandler: nil)
    }
    
    func networkFailureAction() {
        let alert = UIAlertController(title: kEmpty, message: kInternetError, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: kOk, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func successResponse(response: AFDataResponse<Any> ,webManager: WebManager) {
        switch(response.result) {
        case .success(let JSON):
            let result = JSON as! NSDictionary
            if let successresponse = result.object(forKey: "success"){
                if(successresponse as! Bool == false) {
                    let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                        if let details:PodcastDetailsResponse = self.handleResponse(data: jsonData){
                            if let data = details.data{
                                Global.shared.podDetails = data
                                lblName.text = data.podcastName
                                ImageLoader.loadImage(imageView: ivPodcast, url: data.podcastIcon )
                                if let episodeID = episodeID{
                                    for (index,i) in data.pods.enumerated(){
                                        if i.episodeID == episodeID{
                                            lblName.text = i.episodeName
                                            lblEpisode.text = "Episode \(i.episodeID)"
                                            lblDuration.text = i.episodeDuration
                                            activePod = i
                                            Global.shared.currentPlayingIndex = index
                                            MusicPlayer.instance.delegate?.songChanged(pod: i)
                                            found = true
                                            if data.pods.count > index+1{
                                                let next = data.pods[index+1]
                                                ImageLoader.loadImage(imageView: ivNextEpisode, url: data.podcastIcon)
                                                lblNextName.text = next.episodeName
                                            }
                                            if Global.shared.isLiked(id: podCastID){
                                                isLiked = true
                                            }else {
                                                isLiked = false
                                            }
                                            break
                                        }
                                    }
                                }
                                if let first = data.pods.first, !found{
                                    lblName.text = first.episodeName
                                    lblEpisode.text = "Episode \(first.episodeID)"
                                    lblDuration.text = first.episodeDuration
                                    activePod = first
                                    Global.shared.currentPlayingIndex = 0
                                    MusicPlayer.instance.delegate?.songChanged(pod: first)
                                    if data.pods.count > 1{
                                        let next = data.pods[1]
                                        ImageLoader.loadImage(imageView: ivNextEpisode, url: data.podcastIcon)
                                        lblNextName.text = next.episodeName
                                    }
                                    if Global.shared.isLiked(id: podCastID){
                                        isLiked = true
                                    }else {
                                        isLiked = false
                                    }
                                }
                                if let morLikeThis = data.moreLikeThis{
                                    moreArray = morLikeThis
                                    for likeThis in morLikeThis{
                                        profiletitleArr.append(likeThis.podcastName)
                                        profilesubtitleArr.append(likeThis.episodeName)
                                        profiletimeArr.append(likeThis.podcastDuration)
                                        profileimageArr.append(likeThis.podcastIcon)
                                    }
                                    print(details.data?.podcastName)
                                }
                            } else {
                                if let msg = result.object(forKey: "message") as? String{
                                    if msg.contains("unliked successfully"){
                                        for (index,i) in Global.shared.likedPodcast.enumerated().reversed(){
                                            if i == podCastID{
                                                Global.shared.likedPodcast.remove(at: index)
                                            }
                                        }
                                    }else if msg.contains("liked successfully"){
                                        Global.shared.likedPodcast.append(podCastID)
                                    }
                                }
                            }
                        }
                        else {
                            if let msg = result.object(forKey: "message") as? String{
                                if msg == "liked successfully"{
                                    Global.shared.likedPodcast.append(podCastID)
                                }
                                if msg == "unliked successfully"{
                                    Global.shared.likedPodcast.append(podCastID)
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    lipServiceCollectionView.reloadData()
                }
            }
            break
        case .failure(_):
            let alert = UIAlertController(title: "Error", message: "Please enter correct username and password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
}

//MARK:- Music Player
extension LipServiceViewController:MusicDelgate{
    func playerStausChanged(isPlaying: Bool) {
        if !isPlaying{
            ivPlayPause.image = UIImage(named: "ic_iplay")
        }else{
            ivPlayPause.image = UIImage(named: "ic_ipause")
        }
    }
    func songChanged(pod: Pod) {
        lblName.text = Global.shared.podDetails?.podcastName
        lblEpisode.text = pod.episodeName
        lblDuration.text = pod.episodeDuration
        ImageLoader.loadImage(imageView: ivPodcast, url: Global.shared.podDetails?.podcastIcon ?? "")
        if let globalList = Global.shared.podDetails{
            if globalList.pods.count > Global.shared.currentPlayingIndex+1{
                let next = globalList.pods[Global.shared.currentPlayingIndex+1]
                lblNextName.text = next.episodeName
            } else {
                ivNextEpisode.image = nil
                lblNextName.text = "-"
            }
        }
    }
}

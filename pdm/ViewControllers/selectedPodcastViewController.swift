//
//  CategoryViewController.swift
//  pdm
//
//  Created by Mac 2014 on 11/10/2020.
//

import UIKit
import Alamofire

class selectedPodcastViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var podcastname: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var eName: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastCoverImage: UIImageView!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var lblEpisodeDuration: UILabel!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var viewEmpty: UIView!
    
    //MARK:- Actions
    @IBAction func actionPlay(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LipServiceViewController") as! LipServiceViewController
        vc.podCastID = self.podcast.podcastID
        vc.episodeID = Int(self.latestEpisode.episodeID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Veriables
    var podcast = Podcast()
    var episode = Episode()
    var latestEpisode = Episode()
    var moreEpisodes = [Episode](){
        didSet{
            if moreEpisodes.count > 0{
                lblEpisode.alpha = 0
                viewEmpty.alpha = 0
            } else {
                lblEpisode.alpha = 1
                viewEmpty.alpha = 1
            }
        }
    }
    var podcastImageUrl = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemSize = UIScreen.main.bounds.width/3 - 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 40, height: itemSize + 40)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 15
        selectedCollectionView.collectionViewLayout = layout
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        selectedCollectionView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
        
        if podcast.podcastID != ""{
            WebManager.getInstance(delegate: self)?.getSelectedPodcast(selected: self.podcast.podcastID)
        }else if episode.episodeID != ""{
            WebManager.getInstance(delegate: self)?.getSelectedPodcast(selected: self.episode.episodeID)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        MusicPlayer.instance.delegate = self
        if let _ = Global.shared.podcaste{
            guard let _ = Global.shared.universalPlayer else {
                let tabHeight = (self.tabBarController?.tabBar.frame.height ?? 0) + 90
                let y = self.view.frame.maxY-tabHeight
                bottomConstant.constant = -90
                Global.shared.universalPlayer = Global.shared.showPlayer(frame: CGRect(x: 0, y: y, width: self.view.frame.width, height: 90))
                return
            }
            bottomConstant.constant = 90
        } else {
            bottomConstant.constant = 0
        }
        Global.shared.universalPlayer?.refresh()
        Global.shared.universalPlayer?.activeViewController = self
    }
}

//MARK:- Api
extension selectedPodcastViewController: WebManagerDelegate {
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
                    let data = result.object(forKey: kdata) as! NSDictionary
                    if let latest = data.object(forKey: klatest_episode) as? NSDictionary{
                        self.latestEpisode.setEpisodeData(data:  latest)
                    }
                    self.eName.text = self.latestEpisode.eposide_name
                    self.podcastname.text = data.object(forKey: kpodcast_name) as? String
                    self.episodeName.text = self.podcastname.text
                    self.lblDescription.text = data.object(forKey: "episode_description") as? String
                    self.lblEpisodeDuration.text = self.latestEpisode.duration
                    self.podcastImageUrl = (data.object(forKey: "podcast_icon") as? String) ?? ""
                    
                    ImageLoader.loadImage(imageView: podcastCoverImage, url: (data.object(forKey: "user_cover_image") as? String) ?? "")
                    ImageLoader.loadImage(imageView: podcastImageView, url: self.podcastImageUrl)
                    
                    if let episodes = data.object(forKey: kmore_episodes) as? NSArray{
                        self.moreEpisodes.removeAll()
                        for i in 0 ..< episodes.count {
                            let episode = Episode()
                            episode.setEpisodeData(data: episodes[i] as! NSDictionary)
                            self.moreEpisodes.append(episode)
                        }
                    }
                    self.selectedCollectionView.reloadData()
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

//MARK:- CollectionView
extension selectedPodcastViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moreEpisodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vctwo = storyboard?.instantiateViewController(withIdentifier: "v") as? selectedPodcastViewController;
//        self.navigationController?.pushViewController(vctwo!, animated: true)
//        let id = moreEpisodes[indexPath.row].episodeID
//        WebManager.getInstance(delegate: self)?.getSelectedPodcast(selected: id)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController
        vc?.podCastID = self.podcast.podcastID
        vc?.episodeID = Int(moreEpisodes[indexPath.row].episodeID)
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectedCollectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        let cellIndex = indexPath.item
        cell.lblPodcastName.text = self.podcastname.text
        cell.lblEpisodeName.text = self.moreEpisodes[cellIndex].eposide_name
        cell.lblDuration.text = self.moreEpisodes[cellIndex].duration
        ImageLoader.loadImage(imageView: cell.ivImage, url: self.podcastImageUrl)
        return cell
    }
}
//MARK:- Music Player
extension selectedPodcastViewController:MusicDelgate{
    func playerStausChanged(isPlaying: Bool) {
        let player = Global.shared.universalPlayer
        if isPlaying {
            player?.ivPlay.image = UIImage(named: "ic_ipause")
        } else {
            player?.ivPlay.image = UIImage(named: "ic_iplay")
        }
    }
    
    func songChanged(pod: Pod) {
        if let pod = Global.shared.podcaste{
            let player = Global.shared.universalPlayer
            ImageLoader.loadImage(imageView: (player?.ivImage) ?? UIImageView(), url: Global.shared.podDetails?.podcastIcon ?? "")
            player?.lblName.text = Global.shared.podDetails?.podcastName
            player?.lblEpisode.text = pod.episodeName
            if MusicPlayer.instance.isPlaying {
                player?.ivPlay.image = UIImage(named: "ic_ipause")
            } else {
                player?.ivPlay.image = UIImage(named: "ic_iplay")
            }
        }
    }
}

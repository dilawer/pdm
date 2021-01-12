//
//  LikedViewController.swift
//  pdm
//
//  Created by Muhammad Aqeel on 24/12/2020.
//

import UIKit
import Alamofire

class LikedViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var collectionLiked: UICollectionView!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var tfSearch: UITextField!
    
    //MARK:- Action
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSearch(_ sender: Any) {
        guard !(tfSearch.text?.isEmpty ?? false) else {
            return
        }
        if let text = tfSearch.text{
            let vc = storyboard?.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
            vc.searchText = text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Veriable
    var liked = [Podcasts](){
        didSet{
            if liked.isEmpty{
                collectionLiked.alpha = 0
            } else {
                collectionLiked.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        WebManager.getInstance(delegate: self)?.getLikedPodcasts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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

//MARK:- CollectionView
extension LikedViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func register(){
        collectionLiked.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liked.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "LipServiceViewController") as! LipServiceViewController
        let pod = liked[indexPath.row]
        vc.podCastID = String(pod.podcastID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionLiked.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        cell.config(podcast: liked[indexPath.row], width: (self.collectionLiked.frame.width / 2)-30)
        cell.ivLiked.alpha = 1
        cell.likedCallBack = {
            let status = "0"
            WebManager.getInstance(delegate: self)?.LikePodcast(parms: ["podcast_id":self.liked[indexPath.row].podcastID,"liked_status":status])
        }
        return cell
    }
    
}
//MARK:- Api
extension LikedViewController: WebManagerDelegate {
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
            let successresponse = result.object(forKey: "success")!
            if(successresponse as! Bool == false) {
                let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let data = result.object(forKey: kdata) as? NSDictionary{
                    if let categories = data.object(forKey: "liked_podcasts") as? NSArray{
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: categories, options: .prettyPrinted)
                            if let liked:[Podcasts] = self.handleResponse(data: jsonData){
                                self.liked = liked
                                Global.shared.likedPodcast.removeAll()
                                for i in liked{
                                    Global.shared.likedPodcast.append(String(i.podcastID))
                                }
                            }
                            collectionLiked.reloadData()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    WebManager.getInstance(delegate: self)?.getLikedPodcasts()
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
extension LikedViewController:MusicDelgate{
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

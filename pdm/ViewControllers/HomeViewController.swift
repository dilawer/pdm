//
//  HomeViewController.swift
//  pdm
//
//  Created by Mac 2014 on 10/10/2020.
//

import UIKit
import Alamofire
import WebKit

class HomeViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource,UIGestureRecognizerDelegate {
   
    //MARK:- Outlets
    @IBOutlet weak var viewimage: UIView!
    @IBOutlet weak var videomage: UIImageView!
    @IBOutlet weak var bottoncollectionview: UICollectionView!
    @IBOutlet weak var uppercollectionview: UICollectionView!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var ivWebPlay: UIImageView!
    
    //MARK:- Actions
    @IBAction func actionRecording(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func actionLiked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LikedViewController") as! LikedViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionWebPlay(_ sender: Any) {
        webView.alpha = 1
        ivWebPlay.alpha = 0
    }
    
    
    //MARK:- Veriable
    var textArr = [kCATEGORIES]
    var imageArr: [UIImage] = [
        UIImage(named: "ic_category")!,
    ]
    var featuredPodcasts: [Podcast]=[]
    var video = Video()
    var podcastOfTheWeek = Podcast()
    let btimageArr: [UIImage] = [
        UIImage(named: "bottomang")!,
        UIImage(named: "Neck_of_the_Woods")!,
        UIImage(named: "bottomfive")!,
        UIImage(named: "Brilliant_Idiots-Custom")!,
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        Global.shared.Home = self
        Global.shared.activeViewController = self
        uppercollectionview.register(UINib(nibName: "TopCell", bundle: nil), forCellWithReuseIdentifier: "TopCell")
        bottoncollectionview.register(UINib(nibName: "FeaturedCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedCell")
        getHomeData()
        refersh()
        WebManager.getInstance(delegate: self)?.getLikedPodcasts()
    }
    public func refersh(){
        WebManager.getInstance(delegate: self)?.getProfileDetail()
    }
    override func viewDidAppear(_ animated: Bool) {
        MusicPlayer.instance.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if let _ = Global.shared.podcaste{
            guard let _ = Global.shared.universalPlayer else {
                let tabHeight = (self.tabBarController?.tabBar.frame.height ?? 0) + 90
                let y = self.view.frame.maxY-tabHeight
                bottomConstant.constant = -90
                Global.shared.universalPlayer = Global.shared.showPlayer(frame: CGRect(x: 0, y: y, width: self.view.frame.width, height: 90))
                self.bottoncollectionview.reloadData()
                Global.shared.universalPlayer?.refresh()
                Global.shared.universalPlayer?.activeViewController = self
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    self.bottoncollectionview.reloadData()
                })
                return
            }
            self.bottoncollectionview.reloadData()
            bottomConstant.constant = -90
        }else {
            bottomConstant.constant = 0
        }
        Global.shared.universalPlayer?.refresh()
        Global.shared.universalPlayer?.activeViewController = self
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.bottoncollectionview.reloadData()
        })
    }
    func getHomeData(){
        WebManager.getInstance(delegate: self)?.getHomeData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.uppercollectionview {
               return textArr.count
           } 
        else if collectionView == self.bottoncollectionview{
               return featuredPodcasts.count
           }
          
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.uppercollectionview {
            let text = textArr[indexPath.row]
            if text == kCATEGORIES {
                self.tabBarController?.selectedIndex = 2
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController
                vc?.podCastID = podcastOfTheWeek.podcastID
                self.navigationController?.pushViewController(vc!, animated: true)
            }
           }
            else if collectionView == self.bottoncollectionview{
                let vc = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController
                vc?.podCastID = featuredPodcasts[indexPath.row].podcastID
                self.navigationController?.pushViewController(vc!, animated: true)
           }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.uppercollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
            let text = textArr[indexPath.row]
            if text == kCATEGORIES {
                cell.ivImage.image = imageArr[indexPath.row]
            }else{
                ImageLoader.loadImage(imageView: cell.ivImage, url: podcastOfTheWeek.podcast_icon)
            }
            cell.lblName.text = textArr[indexPath.row]
            cell.viewHeight.constant = 60
            return cell
        }
        else if collectionView == self.bottoncollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCell", for: indexPath) as! FeaturedCell
            cell.height.constant = bottoncollectionview.frame.height - 20
            ImageLoader.loadImage(imageView: cell.ivImage, url: featuredPodcasts[indexPath.row].podcast_icon)
            return cell
        }
           
        return UICollectionViewCell()
    }
}

extension HomeViewController: WebManagerDelegate {
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
                let data = result.object(forKey: kdata) as! NSDictionary
                do{
                    if let categories = data.object(forKey: "liked_podcasts") as? NSArray{
                        let jsonData = try JSONSerialization.data(withJSONObject: categories, options: .prettyPrinted)
                        if let liked:[Podcasts] = self.handleResponse(data: jsonData){
                            for i in liked{
                                Global.shared.likedPodcast.append(String(i.podcastID))
                            }
                            return
                        }
                    } else if let user  =  data.object(forKey: "user") as? NSDictionary{
                        if let userPodcast = user["userPodcast"] as? NSDictionary{
                            if let podCastID = userPodcast["id"] as? Int{
                                Global.shared.userPodcastID = String(podCastID)
                                Global.shared.userPodcastImageLink = userPodcast["podcast_icon"] as? String ?? ""
                                Global.shared.userPodcastName = userPodcast["podcast_name"] as? String ?? ""
                                Global.shared.userPodcastCategory = String(userPodcast["category_id"] as? Int ?? 0)
                            }
                        }
                    } else {
                        let podcasts = data.object(forKey: kfeatured) as! NSArray
                        video.setVideoData(data: data.object(forKey: kvideo) as! NSDictionary)
                        var videoLink = video.video_link
                        if !videoLink.contains("embed"){
                            let splited = videoLink.split(separator: "=")
                            videoLink = String("https://www.youtube.com/embed/"+(splited.last ?? "9bZkp7q19f0"))
                        }
                        if let url = URL(string: videoLink){
                            webView.load(URLRequest(url: url))
                        }
                        if let pow = data.object(forKey: kpodcast_of_the_week) as? NSDictionary{
                            podcastOfTheWeek.setPodcastData(data: pow)
                        }
                        Global.shared.podCastOfTheWeek = podcastOfTheWeek
                        featuredPodcasts.removeAll()
                        for i in 0 ..< podcasts.count {
                            let podcast = Podcast()
                            podcast.setPodcastData(data: podcasts[i] as! NSDictionary)
                            featuredPodcasts.append(podcast)
                        }
                        if podcastOfTheWeek.podcastID != ""  {
                            textArr.insert("POD Of The Week", at: 0)
                            imageArr.insert(UIImage(named: "ic_category")!, at: 0)
                        }
                        self.uppercollectionview.reloadData()
                        self.bottoncollectionview.reloadData()
                    }
                }catch{
                    
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
extension HomeViewController:MusicDelgate{
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

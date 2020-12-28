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
    
    //MARK:- Actions
    @IBAction func actionPlay(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LipServiceViewController") as! LipServiceViewController
        vc.podCastID = self.podcast.podcastID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Veriables
    var podcast = Podcast()
    var episode = Episode()
    var latestEpisode = Episode()
    var moreEpisodes: [Episode]=[]
    let profiletitleArr = ["In the Mix","the friend Zone","Shots Film","Kind Advise","Good Advise"]
    let profilesubtitleArr = ["Episode Name","Episode Name","Episode Name","Episode Name","Episode Name"]
    let profiletimeArr = ["40.00","40.00","40.00","40.00","40.00"]
    let profileimageArr: [UIImage] = [
        UIImage(named: "trendingone")!,
        UIImage(named: "trendingone")!,
        UIImage(named: "trendingone")!,
        UIImage(named: "trendingone")!,
        UIImage(named: "trendingone")!,
        UIImage(named: "trendingone")!,
    ]
    
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
        if podcast.podcastID != ""{
            WebManager.getInstance(delegate: self)?.getSelectedPodcast(selected: self.podcast.podcastID)
        }
        if episode.episodeID != ""{
            WebManager.getInstance(delegate: self)?.getSelectedPodcast(selected: self.episode.episodeID)
        }
        
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
                    self.latestEpisode.setEpisodeData(data: data.object(forKey: klatest_episode) as! NSDictionary)
                    self.eName.text = self.latestEpisode.eposide_name
                    self.podcastname.text = data.object(forKey: kpodcast_name) as? String
                    self.episodeName.text = self.latestEpisode.eposide_name
                    self.lblDescription.text = data.object(forKey: "episode_description") as? String
                    self.lblEpisodeDuration.text = self.latestEpisode.duration
                    
                    ImageLoader.loadImage(imageView: podcastCoverImage, url: (data.object(forKey: "user_cover_image") as? String) ?? "")
                    ImageLoader.loadImage(imageView: podcastImageView, url: (data.object(forKey: "podcast_icon") as? String) ?? "")
                    
                    let episodes = data.object(forKey: kmore_episodes) as! NSArray
                    self.moreEpisodes.removeAll()
                    for i in 0 ..< episodes.count {
                        let episode = Episode()
                        episode.setEpisodeData(data: episodes[i] as! NSDictionary)
                        self.moreEpisodes.append(episode)
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
        let id = moreEpisodes[indexPath.row].episodeID
        WebManager.getInstance(delegate: self)?.getSelectedPodcast(selected: id)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilecell", for: indexPath) as! ProfileCollectionViewCell
        let cellIndex = indexPath.item
        cell.cellTitle.text = self.moreEpisodes[cellIndex].eposide_name
        cell.cellsubtitle.text = self.moreEpisodes[cellIndex].eposide_name
        cell.celltime.text = self.moreEpisodes[cellIndex].duration
        cell.layer.cornerRadius = 10
        return cell
    }
}

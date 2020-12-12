//
//  CategoryViewController.swift
//  pdm
//
//  Created by Mac 2014 on 11/10/2020.
//

import UIKit
import Alamofire

class selectedPodcastViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var podcastname: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var eName: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    
    @IBOutlet weak var podcastCoverImage: UIImageView!
    var episode = Episode()
    var latestEpisode = Episode()
    var moreEpisodes: [Episode]=[]
    
    @IBOutlet weak var selectedCollectionView: UICollectionView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemSize = UIScreen.main.bounds.width/3 - 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 40, height: itemSize + 40)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 15
        selectedCollectionView.collectionViewLayout = layout
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        WebManager.getInstance(delegate: self)?.getSelectedPodcast(selected: self.episode.episodeID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moreEpisodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vctwo = storyboard?.instantiateViewController(withIdentifier: "v") as? selectedPodcastViewController;
//        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilecell", for: indexPath) as! ProfileCollectionViewCell
        let cellIndex = indexPath.item
        cell.cellTitle.text = self.moreEpisodes[cellIndex].eposide_name
        cell.cellsubtitle.text = self.moreEpisodes[cellIndex].eposide_name
        cell.celltime.text = self.moreEpisodes[cellIndex].duration
//        cell.profileimage.image  = self.moreEpisodes[cellIndex].file_link
        cell.layer.cornerRadius = 10
        
        return cell
    }
}
extension selectedPodcastViewController: WebManagerDelegate {
    func failureResponse(response: AFDataResponse<Any>) {
     //   activityIndicator.stopAnimating()
//        Utilities.HelperFuntions.delegate.hideProgressBar(self.view)
        Utility.showAlertWithSingleOption(controller: self, title: kEmpty, message: kCannotConnect, preferredStyle: .alert, buttonText: kok, buttonHandler: nil)
    }
    
    func networkFailureAction() {
//        Utility.stopSpinner(activityIndicator: activityIndicator)
//        activityIndicator.stopAnimating()
//        Utilities.HelperFuntions.delegate.hideProgressBar(self.view)

        let alert = UIAlertController(title: kEmpty, message: kInternetError, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: kOk, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func successResponse(response: AFDataResponse<Any> ,webManager: WebManager) {
        
        switch(response.result) {
        case .success(let JSON):
            //SVProgressHUD.dismiss()
            let result = JSON as! NSDictionary
            let successresponse = result.object(forKey: "success")!
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
                self.lblDescription.text = data.object(forKey: kdescription) as? String
                
                let episodes = data.object(forKey: kmore_episodes) as! NSArray
                self.moreEpisodes.removeAll()
                for i in 0 ..< episodes.count {
                    let episode = Episode()
                    episode.setEpisodeData(data: episodes[i] as! NSDictionary)
                    self.moreEpisodes.append(episode)
                }
                self.selectedCollectionView.reloadData()
//                self.newReleasesCollectionView.reloadData()
            }
            break
        case .failure(_):
            //SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error", message: "Please enter correct username and password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
}


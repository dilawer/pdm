//
//  PodcastController.swift
//  pdm
//
//  Created by Mac 2014 on 10/10/2020.
//

import UIKit
import Alamofire

class PodcastController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var uppercollectionview: UICollectionView!
    @IBOutlet weak var trendcollectionview: UICollectionView!
    
    @IBOutlet weak var recomcollectionview: UICollectionView!
    
    @IBOutlet weak var newReleasesCollectionView: UICollectionView!
    
    @IBOutlet weak var recordAction: UIImageView!
    
    
    var trendingEpisodes: [Episode]=[]
    var newReleaseEpisodes: [Episode]=[]
    var recommendedEpisodes: [Episode]=[]
    var podcastOfTheWeek = Podcast()
    
    var textArr : [String]=[]
    let trendtitleArr = ["Lip Service","Brilliant Idiots","Orphan Album"]
    let trendsubtitleArr = ["Episode Name","Episode Name","Episode Name"]
    let trendtimeArr = ["40.00","40.00","40.00"]
    let recomtitleArr = ["In the Mix","Plz Advise","Shots Film"]
    let recomsubtitleArr = ["Episode Name","Episode Name","Episode Name"]
    let recomtimeArr = ["40.00","40.00","40.00"]
    let reltitleArr = ["In the Mix","Plz Advise","Shots Film"]
    let relsubtitleArr = ["Episode Name","Episode Name","Episode Name"]
    let reltimeArr = ["40.00","40.00","40.00"]
    let imageArr: [UIImage] = [
        UIImage(named: "uppercardone")!,
        UIImage(named: "uppercardtwo")!,
    ]
    let trendimageArr: [UIImage] = [
        UIImage(named: "trendingone")!,
        UIImage(named: "trendingtwo")!,
        UIImage(named: "trendingthree")!,
    ]
    let recomimageArr: [UIImage] = [
        UIImage(named: "recomone")!,
        UIImage(named: "recomtwo")!,
        UIImage(named: "recomtwo")!,
    ]
    let releaseimageArr: [UIImage] = [
        UIImage(named: "releaseone")!,
        UIImage(named: "trendingthree")!,
        UIImage(named: "recomtwo")!,
    ]
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "recordServiceViewController") as? recordServiceViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        recordAction.isUserInteractionEnabled = true
        recordAction.addGestureRecognizer(tapGestureRecognizer)
        uppercollectionview.delegate = self
        uppercollectionview.dataSource = self
        trendcollectionview.delegate = self
        trendcollectionview.dataSource = self
        
        let itemSize = UIScreen.main.bounds.width/5 - 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 35, height: itemSize + 35)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        uppercollectionview.collectionViewLayout = layout
        
        let layoutone = UICollectionViewFlowLayout()
        let itemSizetrending = UIScreen.main.bounds.width/3 - 2
        layoutone.scrollDirection = .horizontal
        layoutone.itemSize = CGSize(width: itemSizetrending + 30, height: itemSizetrending + 30)
        layoutone.minimumInteritemSpacing = 10
        layoutone.minimumLineSpacing = 0
        trendcollectionview.collectionViewLayout = layoutone
        
        let layouttwo = UICollectionViewFlowLayout()
        let itemSizerecom = UIScreen.main.bounds.width/3 - 2
        layouttwo.scrollDirection = .horizontal
        layouttwo.itemSize = CGSize(width: itemSizerecom + 30, height: itemSizerecom + 30)
        layouttwo.minimumInteritemSpacing = 10
        layouttwo.minimumLineSpacing = 0
        recomcollectionview.collectionViewLayout = layouttwo
        
        let layoutthree = UICollectionViewFlowLayout()
        let itemSizerel = UIScreen.main.bounds.width/3 - 2
        layoutthree.scrollDirection = .horizontal
        layoutthree.itemSize = CGSize(width: itemSizerel + 30, height: itemSizerel + 30)
        layoutthree.minimumInteritemSpacing = 10
        layoutthree.minimumLineSpacing = 0
        newReleasesCollectionView.collectionViewLayout = layoutthree
        
        WebManager.getInstance(delegate: self)?.getHomeTrendingData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.uppercollectionview {
               return textArr.count
           } else if collectionView == trendcollectionview{
               return trendingEpisodes.count
           }
           else if collectionView == recomcollectionview{
               return recommendedEpisodes.count
           }
           else if collectionView == newReleasesCollectionView{
               return newReleaseEpisodes.count
           }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "selectedPodcastViewController") as? selectedPodcastViewController;
        if collectionView == self.uppercollectionview {
            vctwo?.podcast = podcastOfTheWeek
        }else if collectionView == trendcollectionview{
            vctwo?.episode = self.trendingEpisodes[indexPath.row]
        }else if collectionView == recomcollectionview{
            vctwo?.episode = self.recommendedEpisodes[indexPath.row]
        }else if collectionView == newReleasesCollectionView{
            vctwo?.episode = self.newReleaseEpisodes[indexPath.row]
        }
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        if collectionView == self.uppercollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upperCell", for: indexPath) as! PodcastCollectionViewCell
                WebManager.getInstance(delegate: self)?.downloadImage(imageUrl: podcastOfTheWeek.podcast_icon, imageView: cell.imageCell)
            cell.LabelCell.text = textArr[indexPath.row] as! String
            
            return cell
            }
            else if collectionView == trendcollectionview{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trendcell", for: indexPath) as! TrendCollectionViewCell
                WebManager.getInstance(delegate: self)?.downloadImage(imageUrl: self.trendingEpisodes[indexPath.row].icon, imageView: cell.imagetrend)
                cell.titletrend.text = self.trendingEpisodes[indexPath.row].podcast_name
                cell.episodetrend.text = self.trendingEpisodes[indexPath.row].eposide_name
                cell.timetrend.text = self.trendingEpisodes[indexPath.row].duration
                cell.layer.cornerRadius = 10
                return cell
            }
            else if collectionView == recomcollectionview{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recomcell", for: indexPath) as! RecomCollectionViewCell
                WebManager.getInstance(delegate: self)?.downloadImage(imageUrl: self.recommendedEpisodes[indexPath.row].icon, imageView: cell.recomimage)
                cell.recomtitle.text = self.recommendedEpisodes[indexPath.row].podcast_name
                cell.recomepisode.text = self.recommendedEpisodes[indexPath.row].eposide_name
                cell.recomtime.text = self.recommendedEpisodes[indexPath.row].duration
                cell.layer.cornerRadius = 10
                return cell
            }
            else if collectionView == newReleasesCollectionView{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relcell", for: indexPath) as! releaseCollectionViewCell
            WebManager.getInstance(delegate: self)?.downloadImage(imageUrl: self.newReleaseEpisodes[indexPath.row].icon, imageView: cell.relimage)
                cell.reltitle.text = self.newReleaseEpisodes[indexPath.row].podcast_name
                cell.relsubtitle.text = self.newReleaseEpisodes[indexPath.row].eposide_name
                cell.reltime.text = self.newReleaseEpisodes[indexPath.row].duration
                cell.layer.cornerRadius = 10
                return cell
            }
        return UICollectionViewCell()
    }
}

extension PodcastController: WebManagerDelegate {
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
                podcastOfTheWeek.setPodcastData(data: data.object(forKey: kpodcast_of_the_week) as! NSDictionary)
                if podcastOfTheWeek.podcastID != "" {
                    textArr.insert("Pod \n of the \n week", at: 0)
                }
                self.uppercollectionview.reloadData()
                var episodes = data.object(forKey: ktrending) as! NSArray
                for i in 0 ..< episodes.count {
                    let episode = Episode()
                    episode.setEpisodeData(data: episodes[i] as! NSDictionary)
                    trendingEpisodes.append(episode)
                }
                self.trendcollectionview.reloadData()
                episodes = data.object(forKey: krecommended) as! NSArray
                for i in 0 ..< episodes.count {
                    let episode = Episode()
                    episode.setEpisodeData(data: episodes[i] as! NSDictionary)
                    recommendedEpisodes.append(episode)
                }
                self.recomcollectionview.reloadData()
                episodes = data.object(forKey: knewRelease) as! NSArray
                for i in 0 ..< episodes.count {
                    let episode = Episode()
                    episode.setEpisodeData(data: episodes[i] as! NSDictionary)
                    newReleaseEpisodes.append(episode)
                }
                self.newReleasesCollectionView.reloadData()
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

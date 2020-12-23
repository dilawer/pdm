//
//  HomeViewController.swift
//  pdm
//
//  Created by Mac 2014 on 10/10/2020.
//

import UIKit
import Alamofire
class HomeViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
   
    @IBOutlet weak var viewimage: UIView!
    @IBOutlet weak var videomage: UIImageView!
    
    @IBOutlet weak var bottoncollectionview: UICollectionView!
    
    @IBOutlet weak var uppercollectionview: UICollectionView!
    
    
    
    var textArr = [kCATEGORIES]
    var imageArr: [UIImage] = [
//        UIImage(named: "upperone")!,
        UIImage(named: "uppertwo")!,
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
        view.layer.cornerRadius = 10
        videomage.layer.cornerRadius = 10
        let itemSize = UIScreen.main.bounds.width/5 - 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 40, height: itemSize + 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        uppercollectionview.collectionViewLayout = layout
        
        let itemSizebt = UIScreen.main.bounds.width/5 - 10
       
        let layoutone = UICollectionViewFlowLayout()
        layoutone.scrollDirection = .horizontal
        layoutone.itemSize = CGSize(width: itemSizebt + 30, height: itemSizebt + 30)
        layoutone.minimumInteritemSpacing = 20
        layoutone.minimumLineSpacing = 0
        bottoncollectionview.collectionViewLayout = layoutone
        
        getHomeData()
        
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
                // open categories
                self.tabBarController?.selectedIndex = 2
            }else{
                
                let vc = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController;
//                selectedPodcastViewController?.podcast = podcastOfTheWeek
                vc?.podCastID = podcastOfTheWeek.podcastID
                self.navigationController?.pushViewController(vc!, animated: true)
            }
           }
            else if collectionView == self.bottoncollectionview{
                let vc = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController
//                selectedPodcastViewController?.podcast = featuredPodcasts[indexPath.row]
                vc?.podCastID = featuredPodcasts[indexPath.row].podcastID
                self.navigationController?.pushViewController(vc!, animated: true)
           }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.uppercollectionview {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeupper", for: indexPath) as! HomeUpperCollectionViewCell
            let text = textArr[indexPath.row]
            if text == kCATEGORIES {
                cell.mainimage.image = imageArr[indexPath.row]
            }else{
                WebManager.getInstance(delegate: self)?.downloadImage(imageUrl: podcastOfTheWeek.podcast_name, imageView: cell.mainimage)
            }
            
            cell.mainlabel.text = textArr[indexPath.row]
            
            return cell
            }
        else if collectionView == self.bottoncollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomcell", for: indexPath) as! BottomCollectionViewCell
            WebManager.getInstance(delegate: self)?.downloadImage(imageUrl: featuredPodcasts[indexPath.row].podcast_icon, imageView: cell.bottomimage)
            return cell
            }
           
        return UICollectionViewCell()
    }
}

extension HomeViewController: WebManagerDelegate {
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
                let podcasts = data.object(forKey: kfeatured) as! NSArray
                video.setVideoData(data: data.object(forKey: kvideo) as! NSDictionary)
                podcastOfTheWeek.setPodcastData(data: data.object(forKey: kpodcast_of_the_week) as! NSDictionary)
                featuredPodcasts.removeAll()
                for i in 0 ..< podcasts.count {
                    let podcast = Podcast()
                    podcast.setPodcastData(data: podcasts[i] as! NSDictionary)
                    featuredPodcasts.append(podcast)
                }
                if podcastOfTheWeek.podcastID != ""  {
                    textArr.insert("Pod \n of the \n week", at: 0)
                    imageArr.insert(UIImage(named: "upperone")!, at: 0)
                }
                self.uppercollectionview.reloadData()
                self.bottoncollectionview.reloadData()
                //reload array
                
                
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

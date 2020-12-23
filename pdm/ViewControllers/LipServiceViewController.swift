//
//  LipServiceViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 18/10/2020.
//

import UIKit
import Alamofire

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
    
    //MARK:- Variables
    var profiletitleArr = [String]()
    var profilesubtitleArr = [String]()
    var profiletimeArr = [String]()
    var profileimageArr = [String]()
    var moreArray = [Podcasts]()
    
    var podCastID = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemSize = UIScreen.main.bounds.width/3 - 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 40, height: itemSize + 40)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 15
        lipServiceCollectionView.collectionViewLayout = layout
        WebManager.getInstance(delegate: self)?.getPodcastDetails(podCast_id: podCastID)
        register()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "selectedPodcastViewController") as? selectedPodcastViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        let cellIndex = indexPath.row
        
        cell.config(podcast: moreArray[cellIndex], width: (self.lipServiceCollectionView.frame.width / 2)-20)
//        cell.lblPodcastName.text = profiletitleArr[cellIndex]
//        cell.lblPodcastName.text = profilesubtitleArr[cellIndex]
//        cell.lblDuration.text = profiletimeArr[cellIndex]
//
//        ImageLoader.loadImage(imageView: cell.ivImage, url: profileimageArr[cellIndex])
//        cell.layer.cornerRadius = 10
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
                                lblName.text = data.podcastName
                                ImageLoader.loadImage(imageView: ivPodcast, url: data.podcastIcon )
                                if let first = data.pods.first{
                                    lblName.text = first.episodeName
                                    lblEpisode.text = "Episode \(first.episodeID)"
                                    lblDuration.text = first.episodeDuration
                                }
                                if data.pods.count > 1{
                                    let next = data.pods[1]
                                    ImageLoader.loadImage(imageView: ivNextEpisode, url: data.podcastIcon)
                                    lblNextName.text = next.episodeName
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

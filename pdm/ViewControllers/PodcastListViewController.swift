//
//  PodcastListViewController.swift
//  pdm
//
//  Created by Muhammad Aqeel on 23/12/2020.
//

import UIKit
import Alamofire

class PodcastListViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var collectionPodscasts: UICollectionView!
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
            if let searchVC = searchVC{
                searchVC.searchText = text
                self.navigationController?.popViewController(animated: false)
            } else {
                let vc = storyboard?.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
                vc.searchText = text
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK:- Veriables
    var arrayPodcasts = [Podcasts]()
    var catID = "1"
    var searchVC:SearchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionPodscasts.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
        WebManager.getInstance(delegate: self)?.getPodcastsForCategory(cat_id: catID)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
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
    }
}

//MARK:- CollectionView
extension PodcastListViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPodcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionPodscasts.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        cell.config(podcast: arrayPodcasts[indexPath.row], width: (self.collectionPodscasts.frame.width/2) - 30)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController
        vc?.podCastID = String(arrayPodcasts[indexPath.row].podcastID)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//MARK:- Api
extension PodcastListViewController:WebManagerDelegate{
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
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                        if let searchResult:SearchModel = self.handleResponse(data: jsonData){
                            print(searchResult.data)
                            if let list = searchResult.data.podcasts{
                                self.arrayPodcasts = list
                            }
                        }
                        self.collectionPodscasts.reloadData()
                    } catch {
                        print(error.localizedDescription)
                    }
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
extension PodcastListViewController:MusicDelgate{
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

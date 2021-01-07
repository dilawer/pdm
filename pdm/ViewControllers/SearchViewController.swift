//
//  SearchViewController.swift
//  pdm
//
//  Created by Muhammad Aqeel on 27/12/2020.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionCatgory: UICollectionView!
    @IBOutlet weak var collectionPodcasts: UICollectionView!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    //MARK:- Actions
    @IBAction func actionSearch(_ sender: Any) {
        if let text = tfSearch.text{
            WebManager.getInstance(delegate: self)?.search(query: text)
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Veriables
    var categories = [Category]()
    var podcats = [Podcasts]()
    var searchText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if let text = searchText {
            tfSearch.text = text
            WebManager.getInstance(delegate: self)?.search(query: text)
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
    }
}

//MARK:- Collection
extension SearchViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionCatgory{
            return categories.count
        }
        else {
            return podcats.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionCatgory{
            let cell = collectionCatgory.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let width = self.collectionCatgory.frame.width - 10
            cell.config(category: self.categories[indexPath.row], width: width)
            return cell
        } else {
            let cell = collectionPodcasts.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
            cell.config(podcast: podcats[indexPath.row], width: (self.collectionPodcasts.frame.width / 2) - 30)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionCatgory{
            let vc = storyboard?.instantiateViewController(withIdentifier: "PodcastListViewController") as! PodcastListViewController
            vc.searchVC = self
            vc.catID = categories[indexPath.row].categoryId
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "selectedPodcastViewController") as! selectedPodcastViewController
            let p = self.podcats[indexPath.row]
            let podCast = Podcast()
            podCast.podcastID = String(p.podcastID)
            podCast.podcast_name = p.podcastName
            podCast.podcast_icon = p.podcastIcon
            vc.podcast = podCast
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func register(){
        collectionCatgory.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        collectionPodcasts.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
        self.tfSearch.delegate = self
    }
}

//MARK:- API
extension SearchViewController: WebManagerDelegate {
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
            if let result = JSON as? NSDictionary{
                if let successresponse = result.object(forKey: "success"){
                    if(successresponse as! Bool == false) {
                        let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let data = result.object(forKey: kdata) as! NSDictionary
                        let categories = data.object(forKey: kcategories) as! NSArray
                        self.categories.removeAll()
                        for i in 0 ..< categories.count {
                            let category = Category()
                            category.setCategoryData(data:categories[i] as! NSDictionary)
                            self.categories.append(category)
                        }
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                            if let searchResult:SearchModel = self.handleResponse(data: jsonData){
                                print(searchResult.data)
                                self.categories.removeAll()
                                if let listCat = searchResult.data.categories{
                                    for category in listCat{
                                        let cat = Category()
                                        cat.categoryId = String(category.category_id ?? 0)
                                        cat.category_icon = category.categoryIcon
                                        cat.category_name = category.categoryName
                                        self.categories.append(cat)
                                    }
                                }
                                if let listPodcasts = searchResult.data.podcasts{
                                    self.podcats = listPodcasts
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                        self.collectionPodcasts.reloadData()
                        self.collectionCatgory.reloadData()
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

//MARK:- TextFiedld
extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tfSearch.resignFirstResponder()
        if let text = tfSearch.text{
            WebManager.getInstance(delegate: self)?.search(query: text)
        }
        return true
    }
}
//MARK:- Music Player
extension SearchViewController:MusicDelgate{
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

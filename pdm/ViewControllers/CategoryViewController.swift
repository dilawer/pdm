//
//  CategoryViewController.swift
//  pdm
//
//  Created by Mac 2014 on 11/10/2020.
//

import UIKit
import Alamofire

class CategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //MARK:- Outlets
    @IBOutlet weak var catdowncollectionview: UICollectionView!
    @IBOutlet weak var catupcollectionview: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionCatgory: UICollectionView!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    //MARK:- Action
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
    
    //MARK:- Veriables
    var textArr = ["Trending"]
    let cattextArr = ["News","Sports","Mental Health","Music","Health","Mental Health"]
    var imageArr: [UIImage] = [
        UIImage(named: "ic_trending")!,
    ]
    let catimageArr: [UIImage] = [
        UIImage(named: "Rectangle 1502")!,
        UIImage(named: "Rectangle -4")!,
        UIImage(named: "Rectangle -2")!,
        UIImage(named: "Rectangle -3")!,
        UIImage(named: "Rectangle -6")!,
        UIImage(named: "Rectangle -5")!,
    ]
    var categories: [Category]=[]
    var podcats = [Podcasts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        WebManager.getInstance(delegate: self)?.getCategoriesData()
        register()
    }
    
    func config(){
        let itemSizec = UIScreen.main.bounds.width/3 - 2
        let layoutc = UICollectionViewFlowLayout()
        layoutc.itemSize = CGSize(width: itemSizec + 40, height: itemSizec + 40)
        layoutc.minimumInteritemSpacing = 2
        layoutc.minimumLineSpacing = 15
        if let _ = Global.shared.podCastOfTheWeek{
            textArr.insert("POD Of The Week", at: 0)
            imageArr.insert(UIImage(named: "ic_week")!, at: 0)
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
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
//MARK:- Colelltion View
extension CategoryViewController{
    func register(){
        catdowncollectionview.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        catupcollectionview.register(UINib(nibName: "TopCell", bundle: nil), forCellWithReuseIdentifier: "TopCell")
        self.tfSearch.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.catupcollectionview {
               return textArr.count
        }
        else if collectionView == self.catdowncollectionview {
            return categories.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == catdowncollectionview{
            let vc = storyboard?.instantiateViewController(withIdentifier: "PodcastListViewController") as! PodcastListViewController
            vc.catID = categories[indexPath.row].categoryId
            vc.categories.append(categories[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView == catupcollectionview{
            if indexPath.row == 0{
                if let _ = Global.shared.podCastOfTheWeek{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController
                    vc?.podCastID = Global.shared.podCastOfTheWeek.podcastID
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    self.tabBarController?.selectedIndex = 1
                }
            }
            if indexPath.row == 1{
                self.tabBarController?.selectedIndex = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.catupcollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
            cell.ivImage.image = imageArr[indexPath.row]
            if indexPath.row == 0{
                if Global.shared.podCastOfTheWeek.podcast_icon != nil{
                    ImageLoader.loadImage(imageView: cell.ivImage, url: Global.shared.podCastOfTheWeek.podcast_icon)
                } else {
                    cell.ivImage.image = imageArr[indexPath.row]
                }
            }
//            cell.ivImage.image = imageArr[indexPath.row]
            cell.lblName.text = textArr[indexPath.row]
            return cell
        }
        else if collectionView == self.catdowncollectionview {
            let cell = catdowncollectionview.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let width = self.catdowncollectionview.frame.width/2 - 30
            cell.config(category: self.categories[indexPath.row], width: width)
            cell.cellHeight.constant = width
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK:- Api
extension CategoryViewController: WebManagerDelegate {
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
                                cat.categoryId = String(category.id ?? 0)
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
                self.catdowncollectionview.reloadData()
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
extension CategoryViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tfSearch.resignFirstResponder()
        guard !(tfSearch.text?.isEmpty ?? false) else {
            return true
        }
        if let text = tfSearch.text{
            let vc = storyboard?.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
            vc.searchText = text
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return true
    }
}
//MARK:- Music Player
extension CategoryViewController:MusicDelgate{
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

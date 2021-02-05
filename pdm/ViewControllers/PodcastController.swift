//
//  PodcastController.swift
//  pdm
//
//  Created by Mac 2014 on 10/10/2020.
//

import UIKit
import Alamofire

class PodcastController: UIViewController,UIGestureRecognizerDelegate{
    
    //MARK:- Outlets
    @IBOutlet weak var uppercollectionview: UICollectionView!
    @IBOutlet weak var trendcollectionview: UICollectionView!
    @IBOutlet weak var recomcollectionview: UICollectionView!
    @IBOutlet weak var newReleasesCollectionView: UICollectionView!
    @IBOutlet weak var recordAction: UIImageView!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var lblEmptyTrending: UILabel!
    @IBOutlet weak var lblEmptyRecomended: UILabel!
    @IBOutlet weak var lblEmptyNewRelease: UILabel!
    
    
    //MARK:- Action
    @IBAction func actionRecord(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "recordServiceViewController") as? recordServiceViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    //MARK:- Veriables
    var arrayTrending = [NewRelease](){
        didSet{
            if arrayTrending.count == 0{
                lblEmptyTrending.alpha = 1
            } else {
                lblEmptyTrending.alpha = 0
            }
        }
    }
    var arrayRecommended = [NewRelease](){
        didSet{
            if arrayRecommended.count == 0{
                lblEmptyRecomended.alpha = 1
            } else {
                lblEmptyRecomended.alpha = 0
            }
        }
    }
    var arrayNewRelease = [NewRelease](){
        didSet{
            if arrayNewRelease.count == 0{
                lblEmptyNewRelease.alpha = 1
            } else {
                lblEmptyNewRelease.alpha = 0
            }
        }
    }
    var podWeek:PodcastOfTheWeek?
    var textArr = ["Categories"]
    var imageArr: [UIImage] = [
        UIImage(named: "ic_category")!,
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
        
        if let _ = Global.shared.podCastOfTheWeek{
            textArr.insert("POD Of The Week", at: 0)
            imageArr.insert(UIImage(named: "ic_week")!, at: 0)
        }
        
        uppercollectionview.register(UINib(nibName: "TopCell", bundle: nil), forCellWithReuseIdentifier: "TopCell")
        
        let layoutone = UICollectionViewFlowLayout()
        let itemSizetrending = UIScreen.main.bounds.width/3 - 2
        layoutone.scrollDirection = .horizontal
        layoutone.itemSize = CGSize(width: itemSizetrending + 30, height: itemSizetrending + 20)
        layoutone.minimumInteritemSpacing = 10
        layoutone.minimumLineSpacing = 0
        trendcollectionview.collectionViewLayout = layoutone
        
        let layouttwo = UICollectionViewFlowLayout()
        let itemSizerecom = UIScreen.main.bounds.width/3 - 2
        layouttwo.scrollDirection = .horizontal
        layouttwo.itemSize = CGSize(width: itemSizerecom + 30, height: itemSizerecom + 20)
        layouttwo.minimumInteritemSpacing = 10
        layouttwo.minimumLineSpacing = 0
        recomcollectionview.collectionViewLayout = layouttwo
        
        let layoutthree = UICollectionViewFlowLayout()
        let itemSizerel = UIScreen.main.bounds.width/3 - 2
        layoutthree.scrollDirection = .horizontal
        layoutthree.itemSize = CGSize(width: itemSizerel + 30, height: itemSizerel + 20)
        layoutthree.minimumInteritemSpacing = 10
        layoutthree.minimumLineSpacing = 0
        newReleasesCollectionView.collectionViewLayout = layoutthree
        
        trendcollectionview.register(UINib(nibName: "NewReleaseCell", bundle: nil), forCellWithReuseIdentifier: "NewReleaseCell")
        recomcollectionview.register(UINib(nibName: "NewReleaseCell", bundle: nil), forCellWithReuseIdentifier: "NewReleaseCell")
        newReleasesCollectionView.register(UINib(nibName: "NewReleaseCell", bundle: nil), forCellWithReuseIdentifier: "NewReleaseCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        WebManager.getInstance(delegate: self)?.getHomeTrendingData()
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
                Global.shared.universalPlayer?.refresh()
                Global.shared.universalPlayer?.activeViewController = self
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
extension PodcastController: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.uppercollectionview {
               return textArr.count
           } else if collectionView == trendcollectionview{
               return arrayTrending.count
           }
           else if collectionView == recomcollectionview{
               return arrayRecommended.count
           }
           else if collectionView == newReleasesCollectionView{
               return arrayNewRelease.count
           }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "LipServiceViewController") as! LipServiceViewController
        if collectionView == self.uppercollectionview {
//            vc.podCastID = String(podWeek?.id ?? 0)
            if indexPath.row == 0{
                if let _ = Global.shared.podCastOfTheWeek{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController
                    vc?.podCastID = Global.shared.podCastOfTheWeek.podcastID
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    self.tabBarController?.selectedIndex = 2
                }
            }
            if indexPath.row == 1{
                self.tabBarController?.selectedIndex = 2
            }
            return
        }else if collectionView == trendcollectionview{
            vc.podCastID = String(arrayTrending[indexPath.row].podcastID)
        }else if collectionView == recomcollectionview{
            vc.podCastID = String(arrayRecommended[indexPath.row].podcastID)
        }else if collectionView == newReleasesCollectionView{
            vc.podCastID = String(arrayNewRelease[indexPath.row].podcastID)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.uppercollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
//            ImageLoader.loadImage(imageView: cell.ivImage, url: podWeek?.podcastIcon ?? "")
            cell.lblName.text = textArr[indexPath.row]
            cell.ivImage.image = imageArr[indexPath.row]
            if indexPath.row == 0{
                if Global.shared.podCastOfTheWeek.podcast_icon != nil{
                    ImageLoader.loadImage(imageView: cell.ivImage, url: Global.shared.podCastOfTheWeek.podcast_icon)
                } else {
                    cell.ivImage.image = imageArr[indexPath.row]
                }
            }
            
            return cell
            }
            else if collectionView == trendcollectionview{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewReleaseCell", for: indexPath) as! NewReleaseCell
                ImageLoader.loadImage(imageView: cell.ivImage, url: self.arrayTrending[indexPath.row].podcastIcon)
                cell.lblName.text = self.arrayTrending[indexPath.row].podcastName
                let cat = self.arrayTrending[indexPath.row].episodeName
                cell.lblEpisode.text = cat
                cell.lblDuration.text = self.arrayTrending[indexPath.row].episodeDuration
                cell.layer.cornerRadius = 10
                return cell
            }
            else if collectionView == recomcollectionview{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewReleaseCell", for: indexPath) as! NewReleaseCell
                ImageLoader.loadImage(imageView: cell.ivImage, url: self.arrayRecommended[indexPath.row].podcastIcon)
                cell.lblName.text = self.arrayRecommended[indexPath.row].podcastName
                let cat = self.arrayRecommended[indexPath.row].episodeName
                cell.lblEpisode.text = cat
                cell.lblDuration.text = self.arrayRecommended[indexPath.row].episodeDuration
                return cell
            }
            else if collectionView == newReleasesCollectionView{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewReleaseCell", for: indexPath) as! NewReleaseCell
                ImageLoader.loadImage(imageView: cell.ivImage, url: self.arrayNewRelease[indexPath.row].podcastIcon)
                cell.lblName.text = self.arrayNewRelease[indexPath.row].podcastName
                let cat = self.arrayNewRelease[indexPath.row].episodeName
                cell.lblEpisode.text = cat
                cell.lblDuration.text = self.arrayNewRelease[indexPath.row].episodeDuration
                cell.layer.cornerRadius = 10
                return cell
            }
        return UICollectionViewCell()
    }
}


//MARK:- API
extension PodcastController: WebManagerDelegate {
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
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    if let details:MicsResponse = self.handleResponse(data: jsonData){
                        if let data = details.data{
                            podWeek = data.podcastOfTheWeek
                            arrayTrending = data.trending
                            arrayRecommended = data.recommended
                            arrayNewRelease = data.newRelease
//                            textArr.append(podWeek?.podcastName ?? "Pod of the week")
                        }
                    }
                } catch {
                    
                }
                self.uppercollectionview.reloadData()
                self.trendcollectionview.reloadData()
                self.recomcollectionview.reloadData()
                self.newReleasesCollectionView.reloadData()
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
extension PodcastController:MusicDelgate{
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

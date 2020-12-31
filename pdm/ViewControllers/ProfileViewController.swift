//
//  ProfileViewController.swift
//  pdm
//
//  Created by Mac 2014 on 10/10/2020.
//

import UIKit
import Alamofire
import GoogleSignIn
import FacebookLogin
import AuthenticationServices

class ProfileViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var uploadPostsTapped: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileSettingButton: UIButton!
    @IBOutlet weak var podView: UIView!
    @IBOutlet weak var songsMainView: UIView!
    @IBOutlet weak var totalRecordView: UIView!
    @IBOutlet weak var uploadHistoryView: UIView!
    @IBOutlet weak var uploadTableView: UITableView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var profilecollectionview: UICollectionView!
    @IBOutlet weak var profileDp: UIImageViewX!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var totalListens: UILabel!
    @IBOutlet weak var totalMins: UILabel!
    @IBOutlet weak var uploadedPods: UILabel!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var autoplay: UISwitch!
    
    //MARK:- Action
    @IBAction func actionLiked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LikedViewController") as! LikedViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Alert",
                                      message: "Are you sure?",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
              switch action.style{
              case .default:
                let user = User.getInstance()
                user?.removeUser()
                user?.saveUser()
                GIDSignIn.sharedInstance().signOut()
                LoginManager().logOut()
                MusicPlayer.instance.stop()
                Global.shared.universalPlayer?.removeFromSuperview()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let navVC = appDelegate.window?.rootViewController as? UINavigationController
                navVC?.popViewController(animated: true)
                
              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


        }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func actionPrivacyPolicy(_ sender: Any) {
        if let url = URL(string: kTermsUrl) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func actionTremsandConditions(_ sender: Any) {
        if let url = URL(string: kPrivacyURL) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.userNameLabel.isHidden = false
        self.profileSettingButton.isHidden = false
        self.podView.alpha = 1
        self.totalRecordView.alpha = 1
        self.songsMainView.alpha = 1
        hideBottom()
        self.uploadHistoryView.isHidden = true
    }
    @IBAction func settingsBtnTapped(_ sender: Any) {
        if self.settingsView.isHidden{
            showBottom()
        } else {
            hideBottom()
        }
    }
    @IBAction func actionSwitch(_ sender: Any) {
        if autoplay.isOn{
            UserDefaults.standard.setValue(true, forKey: kAutoPlay)
        } else {
            UserDefaults.standard.setValue(false, forKey: kAutoPlay)
        }
    }
    
    //MARK:- Veriables
    var centerY:CGFloat = 0.0
    var isShowing = false
    var recentPlayedEpisodes: [Episode]=[]
    var settingsHeightConstant:CGFloat = 0.0
    var arrayHistory = [Pod]()
    
    let profiletitleArr = ["In the Mix","the friend Zone","Shots Film","Kind Advise","Good Advise"]
    let profilesubtitleArr = ["Episode Name","Episode Name","Episode Name","Episode Name","Episode Name"]
    let profiletimeArr = ["40.00","40.00","40.00","40.00","40.00"]
    
    let profileimageArr: [UIImage] = [
        UIImage(named: "recomone")!,
        UIImage(named: "releaseone")!,
        UIImage(named: "recomtwo")!,
        UIImage(named: "trendingthree")!,
        UIImage(named: "trendingone")!,
        UIImage(named: "trendingtwo")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    override func viewDidAppear(_ animated: Bool) {
        settingsHeightConstant = self.view.frame.height / 2
        let user = User.getInstance()
        tfEmail.text = user?.email
        tfAge.text = user?.dob
        tfName.text = user?.fullName
    }
    override func viewWillAppear(_ animated: Bool) {
        WebManager.getInstance(delegate: self)?.getProfileDetail()
        WebManager.getInstance(delegate: self)?.getPdmHistory()
        Global.shared.universalPlayer?.alpha = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        Global.shared.universalPlayer?.alpha = 1
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.userNameLabel.isHidden = true
        self.profileSettingButton.isHidden = true
        self.podView.alpha = 0
        self.totalRecordView.alpha = 0
        self.songsMainView.alpha = 0
        hideBottom()
        self.uploadHistoryView.isHidden = false
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer) {
        self.userNameLabel.isHidden = false
        self.profileSettingButton.isHidden = false
        self.podView.alpha = 1
        self.totalRecordView.alpha = 1
        self.songsMainView.alpha = 1
        hideBottom()
//        self.uploadHistoryView.isHidden = true
    }
}
//MARK:- Methods
extension ProfileViewController{
    func config(){
        let itemSize = UIScreen.main.bounds.width/3 - 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 40, height: itemSize + 40)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 15
        profilecollectionview.collectionViewLayout = layout
        settingsView.layer.masksToBounds = true
        settingsView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        settingsView.isHidden = true
        self.uploadHistoryView.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        uploadPostsTapped.isUserInteractionEnabled = true
        uploadPostsTapped.addGestureRecognizer(tapGestureRecognizer)
        uploadHistoryView.layer.masksToBounds = true
        uploadHistoryView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        self.view.addGestureRecognizer(tap)
        
        let user = User.getInstance()
        self.totalListens.text = user?.totalListens
        self.totalMins.text = user?.totalMins
        self.uploadedPods.text = user?.totalUploads
        self.userNameLabel.text = user?.fullName
        self.tfName.text = user?.fullName
        self.tfName.text = user?.fullName
        
        ImageLoader.loadImage(imageView: profileDp, url: user?.profile_image ?? "")
        ImageLoader.loadImage(imageView: profileImageView, url: user?.profile_image ?? "")
        ImageLoader.loadImage(imageView: coverImageView, url: user?.cover_image ?? "")
        
        profilecollectionview.register(UINib(nibName: "NewReleaseCell", bundle: nil), forCellWithReuseIdentifier: "NewReleaseCell")
        
        if UserDefaults.standard.bool(forKey: kAutoPlay){
            autoplay.setOn(true, animated: false)
        } else {
            autoplay.setOn(false, animated: false)
        }
    }
    func showBottom(){
        self.settingsView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.bottomConstant.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    func hideBottom(){
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
            self.bottomConstant.constant = self.settingsHeightConstant
            self.view.layoutIfNeeded()
        },completion: {
            _ in
            self.settingsView.isHidden = true
        })
    }
}

//MARK:- CollectionView
extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentPlayedEpisodes.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        let vc = self.storyboard?.instantiateViewController(identifier: "LipServiceViewController") as! LipServiceViewController
        vc.episodeID = pod.episodeID
        self.navigationController?.pushViewController(vc, animated: true)
 */
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewReleaseCell", for: indexPath) as! NewReleaseCell
        let cellIndex = indexPath.item
        cell.lblName.text = recentPlayedEpisodes[cellIndex].podcast_name
        cell.lblEpisode.text = recentPlayedEpisodes[cellIndex].eposide_name
        cell.lblDuration.text = recentPlayedEpisodes[cellIndex].duration
        ImageLoader.loadImage(imageView: cell.ivImage, url: recentPlayedEpisodes[cellIndex].icon)
        cell.layer.cornerRadius = 10
        return cell
    }
}

//MARK:- TableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == uploadTableView,
           let cell = tableView.dequeueReusableCell(withIdentifier: "uploadCell") as? UploadPDMTableViewCell {
            let pod = arrayHistory[indexPath.row]
            cell.lblAuthor.text = pod.episodeAuthor
            cell.lblDuration.text = pod.episodeDuration
            cell.lblProductName.text = pod.podcast_name
            cell.lblEpisodeName.text = pod.episodeName
            ImageLoader.loadImage(imageView: cell.ivImage, url: pod.podcast_icon ?? "")
            cell.playCallBack = {
                if let podCastID = Global.shared.userPodcastID{
                    let vc = self.storyboard?.instantiateViewController(identifier: "LipServiceViewController") as! LipServiceViewController
                    vc.podCastID = podCastID
                    vc.episodeID = pod.episodeID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.playCallDelete = {
                Utility.showAlertWithOptions(controller: self, title: "Are You Sure", message: "Are You Sure To Delete?", preferredStyle: .alert, rightBtnText: "No", leftBtnText: "Yes", leftBtnhandler: { _ in
                    WebManager.getInstance(delegate: self)?.deletePodCast(String(pod.episodeID))
                }, rightBtnhandler: {_ in
                    
                })
            }
            cell.layer.cornerRadius = 10
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- API'S
extension ProfileViewController: WebManagerDelegate {
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
                if let data = result.object(forKey: kdata) as? NSDictionary{
                    do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    if let episodes = data.object(forKey: krecentlyPlayed) as? NSArray{
                        let user = User.getInstance()
                        user?.setUserData(data: data)
                        user?.totalListens = "\(data.object(forKey: ktotalListens) ?? "")"
                        self.totalListens.text = user?.totalListens
                        user?.totalMins = "\(data.object(forKey: ktotalMinutes) ?? "")"
                        self.totalMins.text = user?.totalMins
                        user?.totalUploads = "\(data.object(forKey: kuploadedPods) ?? "")"
                        self.uploadedPods.text = user?.totalUploads
                        user?.saveUser()
                        if let user  =  data.object(forKey: "user") as? NSDictionary{
                            if let userPodcast = user["userPodcast"] as? NSDictionary{
                                if let podCastID = userPodcast["id"] as? Int{
                                    Global.shared.userPodcastID = String(podCastID)
                                    Global.shared.userPodcastImageLink = userPodcast["podcast_icon"] as? String ?? ""
                                    Global.shared.userPodcastName = userPodcast["podcast_name"] as? String ?? ""
                                    Global.shared.userPodcastCategory = String(userPodcast["category_id"] as? Int ?? 0)
                                }
                            }
                        }
                        self.recentPlayedEpisodes.removeAll()
                        for i in 0 ..< episodes.count {
                            let episode = Episode()
                            episode.setEpisodeData(data: episodes[i] as! NSDictionary)
                            self.recentPlayedEpisodes.append(episode)
                        }
                    }
                    else if let historyArray:PDMHistory = self.handleResponse(data: jsonData){
                        self.arrayHistory = historyArray.pods
                        uploadTableView.reloadData()
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                } else {
                    let alert = UIAlertController(title: "Success", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                        WebManager.getInstance(delegate: self)?.getPdmHistory()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                self.profilecollectionview.reloadData()
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

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = maskLayer
    }
}

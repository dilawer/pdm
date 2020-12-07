//
//  ProfileViewController.swift
//  pdm
//
//  Created by Mac 2014 on 10/10/2020.
//

import UIKit

class ProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    

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
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.userNameLabel.isHidden = true
        self.profileSettingButton.isHidden = true
        self.podView.alpha = 0
        self.totalRecordView.alpha = 0
        self.songsMainView.alpha = 0
        self.settingsView.isHidden = true
        self.uploadHistoryView.isHidden = false
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer) {
        self.userNameLabel.isHidden = false
        self.profileSettingButton.isHidden = false
        self.podView.alpha = 1
        self.totalRecordView.alpha = 1
        self.songsMainView.alpha = 1
        self.settingsView.isHidden = true
        self.uploadHistoryView.isHidden = true
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.userNameLabel.isHidden = false
        self.profileSettingButton.isHidden = false
        self.podView.alpha = 1
        self.totalRecordView.alpha = 1
        self.songsMainView.alpha = 1
        self.settingsView.isHidden = true
        self.uploadHistoryView.isHidden = true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiletitleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "selectedPodcastViewController") as? selectedPodcastViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    @IBAction func settingsBtnTapped(_ sender: Any) {
        settingsView.animShow()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilecell", for: indexPath) as! ProfileCollectionViewCell
        let cellIndex = indexPath.item
        cell.cellTitle.text = profiletitleArr[cellIndex]
        cell.cellsubtitle.text = profilesubtitleArr[cellIndex]
        cell.celltime.text = profiletimeArr[cellIndex]
        cell.profileimage.image  = profileimageArr[cellIndex]
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == uploadTableView,
           let cell = tableView.dequeueReusableCell(withIdentifier: "uploadCell") as? UploadPDMTableViewCell {
            cell.layer.cornerRadius = 10
            return cell
        }
        return UITableViewCell()
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = maskLayer
    }
}

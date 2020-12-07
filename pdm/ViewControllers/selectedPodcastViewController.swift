//
//  CategoryViewController.swift
//  pdm
//
//  Created by Mac 2014 on 11/10/2020.
//

import UIKit

class selectedPodcastViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiletitleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vctwo = storyboard?.instantiateViewController(withIdentifier: "v") as? selectedPodcastViewController;
//        self.navigationController?.pushViewController(vctwo!, animated: true)
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
    
   
}

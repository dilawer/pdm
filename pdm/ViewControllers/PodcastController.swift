//
//  PodcastController.swift
//  pdm
//
//  Created by Mac 2014 on 10/10/2020.
//

import UIKit

class PodcastController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var uppercollectionview: UICollectionView!
    @IBOutlet weak var trendcollectionview: UICollectionView!
    
    @IBOutlet weak var recomcollectionview: UICollectionView!
    
    @IBOutlet weak var relcollectionview: UICollectionView!
    
    @IBOutlet weak var recordAction: UIImageView!
    
    let textArr = ["Pod \n of the","Trending \n pod"]
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
        relcollectionview.collectionViewLayout = layoutthree
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.uppercollectionview {
               return textArr.count
           } else if collectionView == trendcollectionview{
               return trendtitleArr.count
           }
           else if collectionView == recomcollectionview{
               return recomtitleArr.count
           }
           else if collectionView == relcollectionview{
               return reltitleArr.count
           }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "selectedPodcastViewController") as? selectedPodcastViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        if collectionView == self.uppercollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upperCell", for: indexPath) as! PodcastCollectionViewCell
            
            cell.imageCell.image = imageArr[indexPath.row]
            cell.LabelCell.text = textArr[indexPath.row]
            
            return cell
            }
            else if collectionView == trendcollectionview{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trendcell", for: indexPath) as! TrendCollectionViewCell
                
                cell.imagetrend.image = trendimageArr[indexPath.row]
                cell.titletrend.text = trendtitleArr[indexPath.row]
                cell.episodetrend.text = trendsubtitleArr[indexPath.row]
                cell.timetrend.text = trendtimeArr[indexPath.row]
                cell.layer.cornerRadius = 10
                return cell
            }
            else if collectionView == recomcollectionview{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recomcell", for: indexPath) as! RecomCollectionViewCell
                
                cell.recomimage.image = recomimageArr[indexPath.row]
                cell.recomtitle.text = recomtitleArr[indexPath.row]
                cell.recomepisode.text = recomsubtitleArr[indexPath.row]
                cell.recomtime.text = recomtimeArr[indexPath.row]
                cell.layer.cornerRadius = 10
                return cell
            }
            else if collectionView == relcollectionview{
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relcell", for: indexPath) as! releaseCollectionViewCell
                
                cell.relimage.image = releaseimageArr[indexPath.row]
                cell.reltitle.text = reltitleArr[indexPath.row]
                cell.relsubtitle.text = relsubtitleArr[indexPath.row]
                cell.reltime.text = reltimeArr[indexPath.row]
                cell.layer.cornerRadius = 10
                return cell
            }
        return UICollectionViewCell()
    }
    
    

}

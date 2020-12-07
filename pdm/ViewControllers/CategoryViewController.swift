//
//  CategoryViewController.swift
//  pdm
//
//  Created by Mac 2014 on 11/10/2020.
//

import UIKit

class CategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var catdowncollectionview: UICollectionView!
    
    @IBOutlet weak var playButtonTapped: UIImageView!
    @IBOutlet weak var catupcollectionview: UICollectionView!
    let textArr = ["Pod \n of the","Trending \n pod"]
    let cattextArr = ["News","Sports","Mental Health","Music","Health","Mental Health"]
    let imageArr: [UIImage] = [
        UIImage(named: "uppercardone")!,
        UIImage(named: "uppercardtwo")!,
    ]
    let catimageArr: [UIImage] = [
        UIImage(named: "Rectangle 1502")!,
        UIImage(named: "Rectangle -4")!,
        UIImage(named: "Rectangle -2")!,
        UIImage(named: "Rectangle -3")!,
        UIImage(named: "Rectangle -6")!,
        UIImage(named: "Rectangle -5")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemSize = UIScreen.main.bounds.width/5 - 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 35, height: itemSize + 35)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        catupcollectionview.collectionViewLayout = layout
        
        let itemSizec = UIScreen.main.bounds.width/3 - 2
        let layoutc = UICollectionViewFlowLayout()
        layoutc.itemSize = CGSize(width: itemSizec + 40, height: itemSizec + 40)
        layoutc.minimumInteritemSpacing = 2
        layoutc.minimumLineSpacing = 15
        catdowncollectionview.collectionViewLayout = layoutc
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        playButtonTapped.isUserInteractionEnabled = true
        playButtonTapped.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.catupcollectionview {
               return textArr.count
           }
       else  if collectionView == self.catdowncollectionview {
               return cattextArr.count
           }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "selectedPodcastViewController") as? selectedPodcastViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.catupcollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catupcelll", for: indexPath) as! CatUpCollectionViewCell
            
            cell.cellupimage.image = imageArr[indexPath.row]
            cell.celluplabel.text = textArr[indexPath.row]
            
            return cell
            }
       else if collectionView == self.catdowncollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celldown", for: indexPath) as! CatDownCollectionViewCell
            
        cell.celldownimage.image = catimageArr[indexPath.row]
        cell.celldownlabel.text = cattextArr[indexPath.row]
            
            return cell
            }
        
        return UICollectionViewCell()
    }
    
   
}

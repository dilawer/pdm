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
    @IBOutlet weak var playButtonTapped: UIImageView!
    @IBOutlet weak var catupcollectionview: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionCatgory: UICollectionView!
    
    //MARK:- Action
    @IBAction func actionSearch(_ sender: Any) {
        if let text = tfSearch.text{
            WebManager.getInstance(delegate: self)?.search(query: text)
        }
    }
    
    let textArr = ["Pod","Trending"]
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
    var categories: [Category]=[]
    var podcats = [Podcasts]()
    
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
//        catdowncollectionview.collectionViewLayout = layoutc
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        playButtonTapped.isUserInteractionEnabled = true
        playButtonTapped.addGestureRecognizer(tapGestureRecognizer)
        WebManager.getInstance(delegate: self)?.getCategoriesData()
        collectionCatgory.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        catdowncollectionview.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "LipServiceViewController") as? LipServiceViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
}
//MARK:- Colelltion View
extension CategoryViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.catupcollectionview {
               return textArr.count
        }
        else if collectionView == self.collectionCatgory {
            return categories.count
        }
        else if collectionView == self.catdowncollectionview {
            return self.podcats.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "selectedPodcastViewController") as? selectedPodcastViewController;
//        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.catupcollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catupcelll", for: indexPath) as! CatUpCollectionViewCell
            cell.cellupimage.image = imageArr[indexPath.row]
            cell.celluplabel.text = textArr[indexPath.row]
            return cell
        }
        else if collectionView == self.collectionCatgory {
            let cell = collectionCatgory.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.config(category: self.categories[indexPath.row], width: self.collectionCatgory.frame.width-10)
            return cell
        }
        else if collectionView == self.catdowncollectionview{
            let cell = catdowncollectionview.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
            cell.config(podcast: podcats[indexPath.row], width: (self.catdowncollectionview.frame.width / 2) - 30)
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
                        for category in searchResult.data.categories{
                            let cat = Category()
                            cat.categoryId = String(category.categoryID)
                            cat.category_icon = category.categoryIcon
                            cat.category_name = category.categoryName
                            self.categories.append(cat)
                        }
                        self.podcats = searchResult.data.podcasts
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self.collectionCatgory.reloadData()
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


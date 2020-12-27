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
        if let text = searchText {
            WebManager.getInstance(delegate: self)?.search(query: text)
        }
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
    
    func register(){
        collectionCatgory.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        collectionPodcasts.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
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
                                cat.categoryId = String(category.categoryID ?? 0)
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
            
            break
        case .failure(_):
            let alert = UIAlertController(title: "Error", message: "Please enter correct username and password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
}

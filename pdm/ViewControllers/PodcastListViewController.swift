//
//  PodcastListViewController.swift
//  pdm
//
//  Created by Muhammad Aqeel on 23/12/2020.
//

import UIKit
import Alamofire

class PodcastListViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var collectionPodscasts: UICollectionView!
    
    //MARK:- Veriables
    var arrayPodcasts = [Podcasts]()
    var catID = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionPodscasts.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
        WebManager.getInstance(delegate: self)?.getPodcastsForCategory(cat_id: catID)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

//MARK:- CollectionView
extension PodcastListViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPodcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionPodscasts.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        cell.config(podcast: arrayPodcasts[indexPath.row], width: (self.collectionPodscasts.frame.width/2) - 30)
        return cell
    }
}

//MARK:- Api
extension PodcastListViewController:WebManagerDelegate{
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
                    let data = result.object(forKey: kdata) as! NSDictionary
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                        if let searchResult:SearchModel = self.handleResponse(data: jsonData){
                            print(searchResult.data)
                            if let list = searchResult.data.podcasts{
                                self.arrayPodcasts = list
                            }
                        }
                        self.collectionPodscasts.reloadData()
                    } catch {
                        print(error.localizedDescription)
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

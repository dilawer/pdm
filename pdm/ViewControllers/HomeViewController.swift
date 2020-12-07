//
//  HomeViewController.swift
//  pdm
//
//  Created by Mac 2014 on 10/10/2020.
//

import UIKit
import Alamofire
class HomeViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
   
    @IBOutlet weak var viewimage: UIView!
    @IBOutlet weak var videomage: UIImageView!
    
    @IBOutlet weak var bottoncollectionview: UICollectionView!
    
    @IBOutlet weak var uppercollectionview: UICollectionView!
    
    func Api_withParameters() {
        let passingURL = "https://staging.oqh.obm.mybluehost.me/api/home"
        AF.request(passingURL, method: .get)
            .responseJSON { response in
            print(response)
            switch(response.result) {
            case .success(let JSON):
                //SVProgressHUD.dismiss()
                let result = JSON as! NSDictionary
                let successresponse = result.object(forKey: "success")!
                if(successresponse as! Bool == false) {
                    let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let result = result.object(forKey: "user")! as! NSDictionary
                    let id = result["id"]
                    let userName = result["userName"]
                    let fullName = result["fullName"]
                    let email = result["email"]
                    let coverImage = result["coverImage"] as? String
                    let autoplay = result["autoplay"]
                    let dob = result["dob"]
                    let createdAt = result["createdAt"]
                    let updatedAt = result["updatedAt"]
                    let imageURL = result["profileImage"] as? String
//                    self.userDefault!.set(id, forKey: dKeys.keyId)
//                    self.userDefault!.set(userName, forKey: dKeys.keyuserName)
//                    self.userDefault!.set(fullName, forKey: dKeys.keyfullName)
//                    self.userDefault!.set(email, forKey: dKeys.keyemail)
//                    self.userDefault!.set(autoplay, forKey: dKeys.keyautoplay)
//                    self.userDefault!.set(dob, forKey: dKeys.keydob)
//                    self.userDefault!.set(createdAt, forKey: dKeys.keycreatedAt)
//                    self.userDefault!.set(updatedAt, forKey: dKeys.keyupdatedAt)
                    if (imageURL != "") {
                        DispatchQueue.global().async {
                            let fileUrl = URL(string: imageURL!)
                            let data = try? Data(contentsOf:fileUrl!)
//                            self.userDefault!.set(data, forKey: dKeys.keyprofileimage)
//                            self.userDefault!.set(imageURL, forKey: "Link")
                        }
                    }
                    if (coverImage != "") {
                        DispatchQueue.global().async {
                            let fileUrl = URL(string: coverImage!)
                            let data = try? Data(contentsOf:fileUrl!)
//                            self.userDefault!.set(data, forKey: dKeys.keycoverimage)
//                            self.userDefault!.set(imageURL, forKey: "coverLink")
                        }
                    }
                    
                    //self.userDefault!.synchronize()
                    let vcone = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController;
                    self.navigationController?.pushViewController(vcone!, animated: true)
                }
                
                break
            case .failure(_):
                //SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "Please enter correct username and password.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
            }
            
        }
    }
    let textArr = ["Pod \n of the \n week","CATEGORIES","Trending \n pod"]
    let imageArr: [UIImage] = [
        UIImage(named: "upperone")!,
        UIImage(named: "uppertwo")!,
        UIImage(named: "upperthree")!,
    ]
    let btimageArr: [UIImage] = [
        UIImage(named: "bottomang")!,
        UIImage(named: "Neck_of_the_Woods")!,
        UIImage(named: "bottomfive")!,
        UIImage(named: "Brilliant_Idiots-Custom")!,
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 10
        videomage.layer.cornerRadius = 10
        let itemSize = UIScreen.main.bounds.width/5 - 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize + 40, height: itemSize + 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        uppercollectionview.collectionViewLayout = layout
        
        let itemSizebt = UIScreen.main.bounds.width/5 - 3
       
        let layoutone = UICollectionViewFlowLayout()
        layoutone.scrollDirection = .horizontal
        layoutone.itemSize = CGSize(width: itemSizebt + 40, height: itemSizebt + 40)
        layoutone.minimumInteritemSpacing = 0
        layoutone.minimumLineSpacing = 0
        bottoncollectionview.collectionViewLayout = layoutone
        Api_withParameters()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.uppercollectionview {
               return textArr.count
           } 
        else if collectionView == self.bottoncollectionview{
               return btimageArr.count
           }
          
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "selectedPodcastViewController") as? selectedPodcastViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.uppercollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeupper", for: indexPath) as! HomeUpperCollectionViewCell
            
            cell.mainimage.image = imageArr[indexPath.row]
            cell.mainlabel.text = textArr[indexPath.row]
            
            return cell
            }
        else if collectionView == self.bottoncollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomcell", for: indexPath) as! BottomCollectionViewCell
            
            cell.bottomimage.image = btimageArr[indexPath.row]
           
            
            return cell
            }
           
        return UICollectionViewCell()
    }
    

  
}

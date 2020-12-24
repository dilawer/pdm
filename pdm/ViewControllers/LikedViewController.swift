//
//  LikedViewController.swift
//  pdm
//
//  Created by Muhammad Aqeel on 24/12/2020.
//

import UIKit

class LikedViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var collectionLiked: UICollectionView!
    
    //MARK:- Veriable
    var liked = [Podcasts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

//MARK:- CollectionView
extension LikedViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func register(){
        collectionLiked.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liked.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionLiked.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        cell.config(podcast: liked[indexPath.row], width: (self.collectionLiked.frame.width / 2)-20)
        return cell
    }
    
    
}

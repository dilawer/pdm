//
//  NewReleaseCell.swift
//  pdm
//
//  Created by Muhammad Aqeel on 23/12/2020.
//

import UIKit

class RecentCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    //MARK:- Actions
    @IBAction func actionClick(_ sender: Any) {
        if let clicked = clicked{
            clicked()
        }
    }
    
    //MARK:- Veriables
    var clicked:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

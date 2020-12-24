//
//  UploadPDMTableViewCell.swift
//  pdm
//
//  Created by Hamza Iqbal on 18/10/2020.
//

import UIKit

class UploadPDMTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblEpisodeName: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

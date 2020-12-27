//
//  CategoryCell.swift
//  pdm
//
//  Created by Muhammad Aqeel on 22/12/2020.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    //MARK:- Outlet
    @IBOutlet weak var ivImage: UIImageViewX!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(category:Category,width:CGFloat){
        lblName.text = category.category_name
        ImageLoader.loadImage(imageView: ivImage, url: category.category_icon)
        cellWidth.constant = width
    }

}

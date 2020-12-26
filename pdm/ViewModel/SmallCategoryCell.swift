//
//  SmallCategoryCell.swift
//  pdm
//
//  Created by Muhammad Aqeel on 26/12/2020.
//

import UIKit

class SmallCategoryCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var ivImage: UIImageViewX!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewSelected: UIViewX!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(categories:Categorys,width:CGFloat,isSeleted:Bool){
        lblName.text = categories.categoryName
        ImageLoader.loadImage(imageView: ivImage, url: categories.categoryIcon)
        self.width.constant = width
        if isSeleted{
            viewSelected.alpha = 0.5
        } else {
            viewSelected.alpha = 0
        }
    }

}

//
//  ImageLoader.swift
//  pdm
//
//  Created by Muhammad Aqeel on 22/12/2020.
//

import Foundation
import Kingfisher
import UIKit

class ImageLoader{
    var callBack: (()->Void)?
    var imageCallBack: ((UIImage?) -> Void)?
    
    static func loadImage(imageView:UIImageView,url:String,tint:UIColor? = nil){
        var nurl = url
        if nurl.contains("http"){
            
        } else {
            nurl = Global.shared.imageUrl + nurl
        }
        guard let url = URL(string: nurl.replacingOccurrences(of: " ", with: "%20")) else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        imageView.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"),completionHandler: { (image, error, cacheType, imageUrl) in
            if let color = tint{
                imageView.tintColor = color
                imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            }
        })
    }
    func downloadImage(imageView:UIImageView,url:String){
        guard let url = URL(string: url.replacingOccurrences(of: " ", with: "%20")) else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        imageView.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"),completionHandler: { (image, error, cacheType, imageUrl) in
            if let img = image{
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                    if let imageCallBack = self.imageCallBack{
                        imageCallBack(img)
                    }
                })
            }
        })
    }
}

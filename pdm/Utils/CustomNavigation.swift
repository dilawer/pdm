//
//  CustomNavigation.swift
//  Excapade
//
//  Created by Muhammad Aqeel on 23/05/2020.
//  Copyright © 2020 applio. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigation: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        var backImg: UIImage = UIImage(named: "ic_backs") ?? UIImage()
        let leftPadding: CGFloat = 0
        let adjustSizeForBetterHorizontalAlignment: CGSize = CGSize(width: 37, height: 35)

        UIGraphicsBeginImageContextWithOptions(adjustSizeForBetterHorizontalAlignment, false, 0)
        backImg.draw(at: CGPoint(x: leftPadding, y: 0))
        backImg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationBar.backIndicatorImage = backImg
        self.navigationBar.backIndicatorTransitionMaskImage = backImg
        
    }
    
}

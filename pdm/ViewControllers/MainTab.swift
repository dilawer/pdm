//
//  MainTab.swift
//  pdm
//
//  Created by Muhammad Aqeel on 06/01/2021.
//

import UIKit

class MainTab: UITabBarController {

    override func viewDidLoad() {

        let tabBar = self.tabBar

        let homeSelectImage: UIImage! = UIImage(named: "ic_home_selected")?.withRenderingMode(.alwaysOriginal)
        let mic: UIImage! = UIImage(named: "ic_mic_selected")?.withRenderingMode(.alwaysOriginal)
        let profile: UIImage! = UIImage(named: "ic_profile_selected")?.withRenderingMode(.alwaysOriginal)
        let search: UIImage! = UIImage(named: "ic_search_selected")?.withRenderingMode(.alwaysOriginal)

        (tabBar.items![0] ).selectedImage = homeSelectImage
        (tabBar.items![1] ).selectedImage = mic
        (tabBar.items![3] ).selectedImage = profile
        (tabBar.items![2] ).selectedImage = search

        tabBar.tintColor = UIColor.clear

    }
}

//
//  WelcomeViewController.swift
//  pdm
//
//  Created by Muhammad Aqeel on 05/01/2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    //MARK:- Action
    @IBAction func actionContinue(_ sender: Any) {
        let vcone = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController;
        self.navigationController?.pushViewController(vcone!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

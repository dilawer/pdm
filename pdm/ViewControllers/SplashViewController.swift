//
//  SplashViewController.swift
//  pdm
//
//  Created by Muhammad Aqeel on 05/01/2021.
//

import UIKit

class SplashViewController: UIViewController {

    //MARK:- Actions
    @IBAction func actionContinue(_ sender: Any) {
//        listOfFonts()
        let user = User.getInstance()
        if user?.isLogin == true{
            let vcone = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? MainTab
            vcone?.modalPresentationStyle = .fullScreen
            Global.shared.mainTab = vcone
            self.present(vcone!, animated: false, completion: nil)
        }else {
            if let vc = storyboard?.instantiateViewController(identifier: "mainViewController"){
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func listOfFonts(){
        for family in UIFont.familyNames {
            print("family:", family)
            for font in UIFont.fontNames(forFamilyName: family) {
                print("font:", font)
            }
        }
    }
}

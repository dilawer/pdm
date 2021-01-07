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
        if let vc = storyboard?.instantiateViewController(identifier: "mainViewController"){
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
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

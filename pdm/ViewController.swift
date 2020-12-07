//
//  ViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "signinVC") as? SignInViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }


}


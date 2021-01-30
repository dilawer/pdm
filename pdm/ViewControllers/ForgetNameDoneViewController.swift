//
//  ForgetNameDoneViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit

class ForgetNameDoneViewController: UIViewController {

    @IBOutlet weak var emailLabelOutlet: UILabel!
    @IBOutlet weak var returnBtnOutlet: UIButton!
    var type = ""
    var email = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabelOutlet.text = email
    }
    @IBAction func returnByttonTapped(_ sender: Any) {
//        let vc = self.navigationController!.viewControllers[1]
        self.navigationController!.popToRootViewController(animated: true)
    }
}

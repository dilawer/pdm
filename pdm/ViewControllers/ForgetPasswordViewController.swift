//
//  ForgetPasswordViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit

class ForgetPasswordViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var emailTFoutlet: UITextField!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        // Do any additional setup after loading the view.
    }
    
    func customization() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        emailTFoutlet.attributedTextField()
        emailTFoutlet.layer.borderWidth = 1
        emailTFoutlet.layer.borderColor = UIColor.orange.cgColor
        submitBtnOutlet.layer.cornerRadius = 0.5 * submitBtnOutlet.bounds.size.height
        submitBtnOutlet.clipsToBounds = true
    }

    @IBAction func submitBtnTapped(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "otpVC") as? OTPresetPasswordViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
        
    }
}

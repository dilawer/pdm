//
//  ForgetNameViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit

class ForgetNameViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var emailTFoutlet: UITextField!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func customization() {
        emailTFoutlet.attributedTextField()
        emailTFoutlet.layer.borderWidth = 1
        emailTFoutlet.layer.borderColor = UIColor.orange.cgColor
        submitBtnOutlet.layer.cornerRadius = 0.5 * submitBtnOutlet.bounds.size.height
        submitBtnOutlet.clipsToBounds = true
    }

//    forgetNameDoneVC
    @IBAction func submitBtnTapped(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "forgetNameDoneVC") as? ForgetNameDoneViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
}

//extension UITextField {
//    func attributedTextField() {
//        self.borderStyle = .none
//        self.backgroundColor = UIColor.systemBackground
//        self.layer.cornerRadius = self.frame.size.height / 2
//        self.layer.cornerRadius = 0.2 * self.bounds.size.height
//        self.layer.borderWidth = 0.25
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 3.0
//        self.layer.shadowOffset = CGSize.zero // Use any CGSize
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
//        self.leftView = paddingView
//        self.leftViewMode = UITextField.ViewMode.always
//    }
//}

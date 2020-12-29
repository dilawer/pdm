//
//  ForgetNameViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit
import Alamofire

class ForgetNameViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var emailTFoutlet: UITextField!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.customization()
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
        if isValid(){
            WebManager.getInstance(delegate: self)?.forgotUsername(email:emailTFoutlet.text ?? "")
        }
    }
    
}
extension ForgetNameViewController: WebManagerDelegate {
    func failureResponse(response: AFDataResponse<Any>) {
        Utility.showAlertWithSingleOption(controller: self, title: kEmpty, message: kCannotConnect, preferredStyle: .alert, buttonText: kok, buttonHandler: nil)
    }
    
    func networkFailureAction() {
        let alert = UIAlertController(title: kEmpty, message: kInternetError, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: kOk, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func successResponse(response: AFDataResponse<Any> ,webManager: WebManager) {
        
        switch(response.result) {
        case .success(let JSON):
            let result = JSON as! NSDictionary
            let successresponse = result.object(forKey: "success")!
            if(successresponse as! Bool == false) {
                let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let vctwo = storyboard?.instantiateViewController(withIdentifier: "ForgetNameDoneViewController") as? ForgetNameDoneViewController;
                vctwo?.email = emailTFoutlet.text!
                vctwo?.type = "UserName"
                self.navigationController?.pushViewController(vctwo!, animated: true)
//                let user = User.getInstance()
//                user?.setUserData(data: result.object(forKey: kdata)! as! NSDictionary)
//                let vcone = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController;
//                self.navigationController?.pushViewController(vcone!, animated: true)
            }
            
            break
        case .failure(_):
            let alert = UIAlertController(title: "Error", message: "Please enter email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
}
//MARK:- Validation
extension ForgetNameViewController{
    func isValid() -> Bool{
        if emailTFoutlet.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Email is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if !(emailTFoutlet.text ?? "").isValidEmail(){
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Email is not Valid", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        return true
    }
}

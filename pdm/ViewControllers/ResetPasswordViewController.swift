//
//  ResetPasswordViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit
import Alamofire

class ResetPasswordViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var paswwordOutlet: UITextField!
    @IBOutlet weak var confirmPasswordOutlet: UITextField!
    
    //MARK:- Action
    @IBAction func cancel(_ sender: Any) {
        openMain()
    }
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        if isValid(){
            let parms:[String:Any] = [
                "password":paswwordOutlet.text ?? "",
                "confirmPassword":confirmPasswordOutlet.text ?? "",
                "token":tokken!
            ]
            WebManager.getInstance(delegate: self)?.resetPassword(parms: parms)
        }
    }
    
    var compunents:URLComponents!
    var tokken:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        let path = compunents.path
        tokken = "asdhf aks dfajs dfj asdkj "
        // Do any additional setup after loading the view.
    }
    
    func customization() {
        paswwordOutlet.layer.borderWidth = 1
        paswwordOutlet.layer.borderColor = UIColor.orange.cgColor
        confirmPasswordOutlet.layer.borderWidth = 1
        confirmPasswordOutlet.layer.borderColor = UIColor.orange.cgColor
        submitBtnOutlet.layer.cornerRadius = 0.5 * submitBtnOutlet.bounds.size.height
        submitBtnOutlet.clipsToBounds = true
        
        confirmPasswordOutlet.layer.cornerRadius = 0.2 * confirmPasswordOutlet.bounds.size.height
        confirmPasswordOutlet.clipsToBounds = true
        
        paswwordOutlet.layer.cornerRadius = 0.2 * paswwordOutlet.bounds.size.height
        paswwordOutlet.clipsToBounds = true
    }
    
    func openMain(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(identifier: "mainViewController") as! UINavigationController
        rootVC.modalPresentationStyle = .fullScreen
        self.present(rootVC, animated: false, completion: nil)
        
        /*
         let vctwo = storyboard?.instantiateViewController(withIdentifier: "signinVC") as? SignInViewController;
         self.navigationController?.pushViewController(vctwo!, animated: true)
         */
    }
}

//MARK:- Valdation
extension ResetPasswordViewController{
    func isValid() -> Bool{
        if paswwordOutlet.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Password Field is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if !(paswwordOutlet.text ?? "").isValidPassword(){
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Password is Not Valid", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if confirmPasswordOutlet.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Confirm Password Field is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if confirmPasswordOutlet.text != paswwordOutlet.text{
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Password Does Not Match", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        return true
    }
}

//MARK:- Api
extension ResetPasswordViewController:WebManagerDelegate{
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
                openMain()
                /*
                let user = User.getInstance()
                user?.setUserData(data: result.object(forKey: kdata)! as! NSDictionary)
                let vcone = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController;
                self.navigationController?.pushViewController(vcone!, animated: true)
                */
            }
            
            break
        case .failure(_):
            let alert = UIAlertController(title: "Error", message: "Please enter correct username and password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
}

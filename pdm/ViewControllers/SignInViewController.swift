//
//  SignInViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit
import Alamofire
import SVProgressHUD

class SignInViewController: UIViewController, UIGestureRecognizerDelegate {
    let userDefault = UserDefaults(suiteName:"User")
    struct dKeys {
        static let keyId = "id"
        static let keyuserName = "userName"
        static let keyfullName = "fullName"
        static let keyemail = "email"
        static let keyprofileimage = "profileImage"
        static let keycoverimage = "coverImage"
        static let keyautoplay = "autoplay"
        static let keydob = "dob"
        static let keycreatedAt = "createdAt"
        static let keyupdatedAt = "updatedAt"
    }
    @IBOutlet weak var signupButtonOutlet: UIButton!
    @IBOutlet weak var loginSignUpStackView: UIStackView!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var forgotUserNameOutlet: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var continueBtnOutlet: UIButton!
    @IBOutlet weak var continueWithFbOutlet: UIButton!
    @IBOutlet weak var continueWithGoogleOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func customization() {
        loginSignUpStackView.layer.cornerRadius = 0.5 * loginSignUpStackView.bounds.size.height
        loginSignUpStackView.clipsToBounds = true
        signupButtonOutlet.layer.cornerRadius = 0.5 * signupButtonOutlet.bounds.size.height
        signupButtonOutlet.clipsToBounds = true
        loginButtonOutlet.layer.cornerRadius = 0.5 * loginButtonOutlet.bounds.size.height
        loginButtonOutlet.clipsToBounds = true
        loginButtonOutlet.backgroundColor = UIColor.orange
        signupButtonOutlet.backgroundColor = UIColor.clear
        
        continueBtnOutlet.layer.cornerRadius = 0.2 * continueBtnOutlet.bounds.size.height
//        continueBtnOutlet.clipsToBounds = true
        
        continueBtnOutlet.layer.borderColor = UIColor.white.cgColor
        continueBtnOutlet.layer.shadowOpacity = 1
        continueBtnOutlet.layer.shadowRadius = 3.0
        continueBtnOutlet.layer.shadowOffset = CGSize.zero // Use any CGSize
        continueBtnOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        
        continueWithFbOutlet.layer.cornerRadius = 0.2 * continueWithFbOutlet.bounds.size.height
        continueWithFbOutlet.clipsToBounds = true
        continueWithFbOutlet.layer.borderWidth = 1
        continueWithFbOutlet.layer.borderColor = UIColor.orange.cgColor
        continueWithGoogleOutlet.layer.cornerRadius = 0.2 * continueWithGoogleOutlet.bounds.size.height
        continueWithGoogleOutlet.clipsToBounds = true
        continueWithGoogleOutlet.layer.borderWidth = 1
        continueWithGoogleOutlet.layer.borderColor = UIColor.orange.cgColor
        
        userNameTF.attributedTextField()
        passwordTF.attributedTextField()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if(loginButtonOutlet.backgroundColor == UIColor.orange) {
            signupButtonOutlet.backgroundColor = UIColor.clear
        } else {
            loginButtonOutlet.backgroundColor = UIColor.orange
            signupButtonOutlet.backgroundColor = UIColor.clear
        }
    }
    @IBAction func signupButtonTapped(_ sender: Any) {
        if(signupButtonOutlet.backgroundColor == UIColor.orange) {
            loginButtonOutlet.backgroundColor = UIColor.clear
        } else {
            signupButtonOutlet.backgroundColor = UIColor.orange
            loginButtonOutlet.backgroundColor = UIColor.clear
        }
        
    }
    @IBAction func forgotUserName(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "forgotNameVC") as? ForgetNameViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "forgotPasswordVC") as? ForgetPasswordViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    func Api_withParameters(aDictParam : Dictionary<String, Any>) {
        let passingURL = "https://staging.oqh.obm.mybluehost.me/api/auth/login"
        //SVProgressHUD.show()
        AF.request(passingURL, method: HTTPMethod.post,
                          parameters: aDictParam)
          .responseJSON { response in
            print(response)
            switch(response.result) {
            case .success(let JSON):
                //SVProgressHUD.dismiss()
                let result = JSON as! NSDictionary
                let successresponse = result.object(forKey: "success")!
                if(successresponse as! Bool == false) {
                    let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let result = result.object(forKey: "user")! as! NSDictionary
                    let id = result["id"]
                    let userName = result["userName"]
                    let fullName = result["fullName"]
                    let email = result["email"]
                    let coverImage = result["coverImage"] as? String
                    let autoplay = result["autoplay"]
                    let dob = result["dob"]
                    let createdAt = result["createdAt"]
                    let updatedAt = result["updatedAt"]
                    let imageURL = result["profileImage"] as? String
                    self.userDefault!.set(id, forKey: dKeys.keyId)
                    self.userDefault!.set(userName, forKey: dKeys.keyuserName)
                    self.userDefault!.set(fullName, forKey: dKeys.keyfullName)
                    self.userDefault!.set(email, forKey: dKeys.keyemail)
                    self.userDefault!.set(autoplay, forKey: dKeys.keyautoplay)
                    self.userDefault!.set(dob, forKey: dKeys.keydob)
                    self.userDefault!.set(createdAt, forKey: dKeys.keycreatedAt)
                    self.userDefault!.set(updatedAt, forKey: dKeys.keyupdatedAt)
                    if (imageURL != "") {
                        DispatchQueue.global().async {
                            let fileUrl = URL(string: imageURL!)
                            let data = try? Data(contentsOf:fileUrl!)
                            self.userDefault!.set(data, forKey: dKeys.keyprofileimage)
                            self.userDefault!.set(imageURL, forKey: "Link")
                        }
                    }
                    if (coverImage != "") {
                        DispatchQueue.global().async {
                            let fileUrl = URL(string: coverImage!)
                            let data = try? Data(contentsOf:fileUrl!)
                            self.userDefault!.set(data, forKey: dKeys.keycoverimage)
                            self.userDefault!.set(imageURL, forKey: "coverLink")
                        }
                    }
                    
                    self.userDefault!.synchronize()
                    let vcone = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController;
                    self.navigationController?.pushViewController(vcone!, animated: true)
                }
                
                break
            case .failure(_):
                //SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "Please enter correct username and password.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
            }
            
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let dict : [String:Any] = ["username": userNameTF.text!, "password": passwordTF.text!, "is_email" : "2"]
        Api_withParameters(aDictParam: dict)
    }
    @IBAction func continueWithFBTapped(_ sender: Any) {
        let vcone = storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController;
        self.navigationController?.pushViewController(vcone!, animated: true)
    }
    @IBAction func continueWithGoogleTapped(_ sender: Any) {
        let vcone = storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController;
        self.navigationController?.pushViewController(vcone!, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UITextField {
    func attributedTextField() {
        self.borderStyle = .none
        self.backgroundColor = UIColor.systemBackground
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.cornerRadius = 0.2 * self.bounds.size.height
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize.zero // Use any CGSize
        self.layer.shadowColor = UIColor.lightGray.cgColor
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
}

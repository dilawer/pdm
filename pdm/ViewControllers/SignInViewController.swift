//
//  SignInViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit
import Alamofire
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

class SignInViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var signupButtonOutlet: UIButton!
    @IBOutlet weak var loginSignUpStackView: UIStackView!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var usernameSignupTF: UITextField!
    @IBOutlet weak var passwordSignupTF: UITextField!
    @IBOutlet weak var confirmPassSignupTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var forgotUserNameOutlet: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var continueBtnOutlet: UIButton!
    @IBOutlet weak var continueWithFbOutlet: UIButton!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var continueWithGoogleOutlet: UIButton!
    @IBOutlet weak var continueSignup: UIButton!
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var btnPrivacy: UIButton!
    
    //MARK:- Action
    @IBAction func actionPrivacy(_ sender: Any) {
        if let url = URL(string: kPrivacyURL) {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK:- Veriables
    var loginType:LoginType = .userName
    var datePicker:UIDatePicker = UIDatePicker()
    let loginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.customization()
        setLoginSeleted()
        self.navigationController?.isNavigationBarHidden = true
        self.passwordTF.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        tfDOB.inputView = datePicker
        dobTF.text = Date().getString(format: "dd-MM-yyyy")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let user = User.getInstance()
        if user?.isLogin == true{
            let vcone = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController
            vcone?.modalPresentationStyle = .fullScreen
            self.present(vcone!, animated: false, completion: nil)
//            self.navigationController?.pushViewController(vcone!, animated: false)
        }
    }
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            tfDOB.text = "\(day)-\(String(format: "%02d", month))-\(year)"
            print("\(day) \(month) \(year)")
//            tfDOB.resignFirstResponder()
        }
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
        continueBtnOutlet.layer.borderColor = UIColor.white.cgColor
        continueBtnOutlet.layer.shadowOpacity = 1
        continueBtnOutlet.layer.shadowRadius = 3.0
        continueBtnOutlet.layer.shadowOffset = CGSize.zero // Use any CGSize
        continueBtnOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        
        continueSignup.layer.cornerRadius = 0.2 * continueBtnOutlet.bounds.size.height
        continueSignup.layer.borderColor = UIColor.white.cgColor
        continueSignup.layer.shadowOpacity = 1
        continueSignup.layer.shadowRadius = 3.0
        continueSignup.layer.shadowOffset = CGSize.zero // Use any CGSize
        continueSignup.layer.shadowColor = UIColor.lightGray.cgColor
        
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
        usernameSignupTF.attributedTextField()
        passwordSignupTF.attributedTextField()
        confirmPassSignupTF.attributedTextField()
        nameTF.attributedTextField()
        dobTF.attributedTextField()
        tfEmail.attributedTextField()
        
        
        setLoginSeleted()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        setLoginSeleted()
    }
    @IBAction func signupButtonTapped(_ sender: Any) {
        setSignupSelected()
    }
    @IBAction func forgotUserName(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "forgotNameVC") as? ForgetNameViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "forgotPasswordVC") as? ForgetPasswordViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        signin()
    }
    @IBAction func continueSignup(_ sender: Any) {
        if isSignupValid(){
            WebManager.getInstance(delegate: self)?.signUp(name: tfUserName.text ?? "", email: tfEmail.text ?? "", pass: tfPassword.text ?? "", confirmPass: tfConfirmPassword.text ?? "", fullName: tfFullName.text ?? "", dob: tfDOB.text ?? "")
        }
    }
    
    @IBAction func continueWithFBTapped(_ sender: Any) {
        goFacebook()
    }
    @IBAction func continueWithGoogleTapped(_ sender: Any) {
        signIngoogle()
    }
    @IBAction func continueWithAppleTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            requestApple()
        } else {
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Only Available on iOS 13 Above", preferredStyle: .alert, buttonText: "OK")
        }
    }
    
}
extension SignInViewController: WebManagerDelegate {
    func failureResponse(response: AFDataResponse<Any>) {
     //   activityIndicator.stopAnimating()
//        Utilities.HelperFuntions.delegate.hideProgressBar(self.view)
        Utility.showAlertWithSingleOption(controller: self, title: kEmpty, message: kCannotConnect, preferredStyle: .alert, buttonText: kok, buttonHandler: nil)
    }
    
    func networkFailureAction() {
//        Utility.stopSpinner(activityIndicator: activityIndicator)
//        activityIndicator.stopAnimating()
//        Utilities.HelperFuntions.delegate.hideProgressBar(self.view)

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
                GIDSignIn.sharedInstance().signOut()
                let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let user = User.getInstance()
                user?.setUserData(data: result.object(forKey: kdata)! as! NSDictionary)
                let vcone = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController")
                self.navigationController?.pushViewController(vcone!, animated: true)
            }
            
            break
        case .failure(_):
            let alert = UIAlertController(title: "Error", message: "Please enter correct username and password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    func signin(){
        if isValid(){
            let userName = userNameTF.text
            let password = passwordTF.text
            WebManager.getInstance(delegate: self)?.signInWithEmail(email: userName!, pass: password!, type: loginType)
        }
    }
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
//MARK:- Signin
extension SignInViewController{
    func setLoginSeleted(){
        if(loginButtonOutlet.backgroundColor == UIColor.orange) {
            signupButtonOutlet.backgroundColor = UIColor.clear
        } else {
            loginButtonOutlet.backgroundColor = UIColor.orange
            signupButtonOutlet.backgroundColor = UIColor.clear
        }
        signupButtonOutlet.setTitleColor(.black, for: .normal)
        loginButtonOutlet.setTitleColor(.white, for: .normal)
        self.loginView.isHidden = false
        self.signupView.isHidden = true
        btnPrivacy.alpha = 0
    }
    func setSignupSelected(){
        if(signupButtonOutlet.backgroundColor == UIColor.orange) {
            loginButtonOutlet.backgroundColor = UIColor.clear
        } else {
            signupButtonOutlet.backgroundColor = UIColor.orange
            loginButtonOutlet.backgroundColor = UIColor.clear
        }
        signupButtonOutlet.setTitleColor(.white, for: .normal)
        loginButtonOutlet.setTitleColor(.black, for: .normal)
        self.loginView.isHidden = true
        self.signupView.isHidden = false
        btnPrivacy.alpha = 1
    }
}
//MARK:- Validation
extension SignInViewController{
    func isValid() -> Bool{
        if userNameTF.text?.isEmpty ?? true {
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Username OR Email is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if (userNameTF.text ?? "").contains("@"){
            if !(userNameTF.text ?? "").isValidEmail(){
                Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Email is Not Valid", preferredStyle: .alert, buttonText: "OK")
                return false
            }
            loginType = .email
        } else {
            loginType = .userName
        }
        if passwordTF.text?.isEmpty ?? true {
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Password is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if (passwordTF.text?.count ?? 0) < 6{
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Invalid Password", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        return true
    }
    func isSignupValid() -> Bool{
        if tfUserName.text?.isEmpty ?? true {
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Username is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfEmail.text?.isEmpty ?? true {
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Email is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if !(tfEmail.text ?? "").isValidEmail(){
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Email is Not Valid", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfPassword.text?.isEmpty ?? true {
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Password is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if (tfPassword.text?.count ?? 0) < 6{
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Password Must Be At Least 6 Digit Long", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfConfirmPassword.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Confirm Password is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if (tfPassword.text ?? "") != (tfConfirmPassword.text ?? ""){
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Password Does Not Matched", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfFullName.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Full Name is required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfDOB.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Validation Error", message: "Date of Birth is required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        return true
    }
}
//MARK:- Google
extension SignInViewController: GIDSignInDelegate{
    func signIngoogle(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = Global.shared.clientID
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        } else {
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Login Canceled", preferredStyle: .alert, buttonText: "OK")
        } else {
            let userId = user.userID ?? ""
            let idToken = user.authentication.idToken
            let fullName = user.profile.name ?? ""
            let givenName = user.profile.givenName ?? ""
            let familyName = user.profile.familyName ?? ""
            let email = user.profile.email ?? ""
            WebManager.getInstance(delegate: self)?.socialLogin(provider: "google", email: email, id: userId, given_name: givenName, family_name: familyName)
       }
    }
}
//MARK:- Facebook
extension SignInViewController{
    func goFacebook(){
        let loginManager: LoginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: {
            result,error  in
            if let error = error{
                Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Error With Facebook Login", preferredStyle: .alert, buttonText: "OK")
            }
            if let result = result{
                if result.isCancelled {
                    Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "User Cancel Login", preferredStyle: .alert, buttonText: "OK")
                }
                if let tokken = result.token{
                    print(tokken)
                    self.fetchFacebookProfileInfo(token: tokken)
                }
            } else{
                Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Error With Facebook Login", preferredStyle: .alert, buttonText: "OK")
            }
        })
    }
    func fetchFacebookProfileInfo(token:AccessToken){
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, gender, last_name, location, hometown, picture.type(large)"]))
        {
            httpResponse, result, error in
            if let res = result as? [String:Any]{
                let firstName = res["first_name"] as? String ?? ""
                let lastName = res["last_name"] as? String ?? ""
                let email = res["email"] as? String ?? ""
                let id = res["id"] as? String ?? ""
                WebManager.getInstance(delegate: self)?.socialLogin(provider: "facebook", email: email, id: id, given_name: firstName, family_name: lastName)
            }
        }
        connection.start()
    }
}
//MARK:- Apple Signin
@available(iOS 13.0, *)
extension SignInViewController:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
    func requestApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            print(appleIDCredential)
            guard let _ = appleIDCredential.fullName?.givenName else {
                let defaults = UserDefaults.standard
                guard let firstName = defaults.string(forKey: kAppleFirst) else {
                    Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "There is an error while reterving your id please go to \niPhone Settings > Apple Id > Password & Security > Apple ID logins > PDM App > Stop using Apple ID", preferredStyle: .alert, buttonText: "OK")
                    return
                }
                let lastName = defaults.string(forKey: kAppleLast) ?? ""
                let email = defaults.string(forKey: kAppleEmail) ?? ""
                let id = defaults.string(forKey: kAppleId) ?? ""
                WebManager.getInstance(delegate: self)?.socialLogin(provider: "apple", email: email, id: id, given_name: firstName, family_name: lastName)
                return
            }
            let firstName = appleIDCredential.fullName?.givenName ?? ""
            let lastName = appleIDCredential.fullName?.familyName ?? ""
            let email = appleIDCredential.email ?? ""
            let id = appleIDCredential.user
            let defaults = UserDefaults.standard
            defaults.setValue(firstName, forKey: kAppleFirst)
            defaults.setValue(lastName, forKey: kAppleLast)
            defaults.setValue(email, forKey: kAppleEmail)
            defaults.setValue(id, forKey: kAppleId)
            WebManager.getInstance(delegate: self)?.socialLogin(provider: "apple", email: email, id: id, given_name: firstName, family_name: lastName)
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
        default:
            break
        }
    }
}
//MARK:- TextFiedld
extension SignInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.passwordTF.resignFirstResponder()
        signin()
        return true
    }
}

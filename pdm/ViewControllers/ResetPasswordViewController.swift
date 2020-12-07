//
//  ResetPasswordViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var paswwordOutlet: UITextField!
    @IBOutlet weak var confirmPasswordOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
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
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "signinVC") as? SignInViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
}

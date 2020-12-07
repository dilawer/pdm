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
    override func viewDidLoad() {
        super.viewDidLoad()
        returnBtnOutlet.layer.cornerRadius = 0.5 * returnBtnOutlet.bounds.size.height
        returnBtnOutlet.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    @IBAction func returnByttonTapped(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "signinVC") as? SignInViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
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

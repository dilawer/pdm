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
    var email = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        returnBtnOutlet.layer.cornerRadius = 0.5 * returnBtnOutlet.bounds.size.height
        returnBtnOutlet.clipsToBounds = true
        emailLabelOutlet.text = email
        // Do any additional setup after loading the view.
    }
    @IBAction func returnByttonTapped(_ sender: Any) {
        let vc = self.navigationController!.viewControllers[1]
        self.navigationController!.popToViewController(vc, animated: true)

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

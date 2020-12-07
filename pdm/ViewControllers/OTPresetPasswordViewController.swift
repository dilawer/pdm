//
//  OTPresetPasswordViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 02/10/2020.
//

import UIKit

class OTPresetPasswordViewController: UIViewController {

    @IBOutlet weak var t1: UITextField!
    @IBOutlet weak var t2: UITextField!
    @IBOutlet weak var t3: UITextField!
    @IBOutlet weak var t4: UITextField!
    @IBOutlet weak var t5: UITextField!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        // Do any additional setup after loading the view.
    }
    
    func customization() {
        submitBtnOutlet.layer.cornerRadius = 0.5 * submitBtnOutlet.bounds.size.height
        submitBtnOutlet.clipsToBounds = true
    }

    @IBAction func SubmitButtonTapped(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "resetVC") as? ResetPasswordViewController;
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

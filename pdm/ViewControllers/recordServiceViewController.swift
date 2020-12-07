//
//  recordServiceViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 27/10/2020.
//

import UIKit

class recordServiceViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.masksToBounds = true
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 15)
        bottomView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadFileAction(_ sender: Any) {
        bottomView.animShow()
    }
    
    @IBAction func startRecording(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "podcastRecordingViewController") as? podcastRecordingViewController;
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

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}

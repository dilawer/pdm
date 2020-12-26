//
//  recordServiceViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 27/10/2020.
//

import UIKit
import MediaPlayer

class recordServiceViewController: UIViewController {

    //MARK:- Outltes
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.masksToBounds = true
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 15)
        bottomView.isHidden = true
    }
    
    @IBAction func uploadFileAction(_ sender: Any) {
        bottomView.animShow()
    }
    
    @IBAction func actionFile(_ sender: Any) {
        bottomView.animHide()
        let picker = MPMediaPickerController(mediaTypes: .music)
        picker.allowsPickingMultipleItems = false
        picker.popoverPresentationController?.sourceView = view
        picker.showsCloudItems = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        print(picker.view.frame )
    }
    @IBAction func actionRSS(_ sender: Any) {
    }
    @IBAction func actionDropBox(_ sender: Any) {
    }
    @IBAction func actionDrive(_ sender: Any) {
    }
    
    
    @IBAction func startRecording(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "podcastRecordingViewController") as? podcastRecordingViewController;
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
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
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
        })
    }
}

//MARK:- MediaPicker
extension recordServiceViewController:MPMediaPickerControllerDelegate{
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        self.dismiss(animated: true, completion: nil)
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

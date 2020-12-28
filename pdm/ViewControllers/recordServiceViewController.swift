//
//  recordServiceViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 27/10/2020.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import SVProgressHUD

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
        picker()
        /*
        let picker = MPMediaPickerController(mediaTypes: .music)
        picker.allowsPickingMultipleItems = false
        picker.popoverPresentationController?.sourceView = view
        picker.showsCloudItems = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        print(picker.view.frame )
         */
    }
    @IBAction func actionRSS(_ sender: Any) {
        bottomView.animHide()
        picker()
    }
    @IBAction func actionDropBox(_ sender: Any) {
        bottomView.animHide()
        picker()
    }
    @IBAction func actionDrive(_ sender: Any) {
        bottomView.animHide()
        picker()
    }
    @IBAction func startRecording(_ sender: Any) {
        let vctwo = storyboard?.instantiateViewController(withIdentifier: "podcastRecordingViewController") as? podcastRecordingViewController
        self.navigationController?.pushViewController(vctwo!, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        Global.shared.universalPlayer?.alpha = 0
        MusicPlayer.instance.pause()
    }
    override func viewWillDisappear(_ animated: Bool) {
        Global.shared.universalPlayer?.alpha = 1
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
//MARK:- Document Picker
extension recordServiceViewController:UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        print("import result : \(myURL)")
        var audioArray = [Float]()
        SVProgressHUD.show(withStatus: "Importing Audio")
        averagePowers(audioFileURL: myURL, forChannel: 0, completionHandler: { array in
            audioArray = array
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                let audioAsset = AVURLAsset.init(url: myURL, options: nil)
                let duration = audioAsset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                
                let vc = self.storyboard?.instantiateViewController(identifier: "UploadViewController") as! UploadViewController
                vc.array = audioArray
                vc.length = durationInSeconds.stringFromTimeInterval()
                do{
                    let audio = try Data(contentsOf: myURL)
                    vc.audio = audio
                }catch{
                    
                }
                vc.sceonds = Int(durationInSeconds)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }


    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    func picker(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypeAudio)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}

//MARK:- Meters
extension recordServiceViewController{
    func averagePowers(audioFileURL: URL, forChannel channelNumber: Int, completionHandler: @escaping(_ success: [Float]) -> ()) {
        let audioFile = try! AVAudioFile(forReading: audioFileURL)
        let audioFilePFormat = audioFile.processingFormat
        let audioFileLength = audioFile.length
        let frameSizeToRead = Int(audioFilePFormat.sampleRate/20)
        let numberOfFrames = Int(audioFileLength)/frameSizeToRead
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFilePFormat, frameCapacity: AVAudioFrameCount(frameSizeToRead)) else {
            fatalError("Couldn't create the audio buffer")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            var returnArray : [Float] = [Float]()
            for i in 0..<numberOfFrames {
                audioFile.framePosition = AVAudioFramePosition(i * frameSizeToRead)
                try! audioFile.read(into: audioBuffer, frameCount: AVAudioFrameCount(frameSizeToRead))
                let channelData = audioBuffer.floatChannelData![channelNumber]
                let arr = Array(UnsafeBufferPointer(start:channelData, count: frameSizeToRead))
                let meanValue = arr.reduce(0, {$0 + abs($1)})/Float(arr.count)
                let dbPower: Float = meanValue > 0.000_000_01 ? 20 * log10(meanValue) : -160.0
                let percentage: Float = pow(10, (0.05 * dbPower))
                if (percentage > 0.2) && (percentage < 0.9){
                    returnArray.append(percentage)
                }
            }
            completionHandler(returnArray)
        }
    }
}

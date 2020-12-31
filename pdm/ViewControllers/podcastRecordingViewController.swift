//
//  podcastRecordingViewController.swift
//  pdm
//
//  Created by Hamza Iqbal on 27/10/2020.
//

import UIKit
import SoundWave

class podcastRecordingViewController: UIViewController, UIGestureRecognizerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var viewRecording: UIViewCircular!
    @IBOutlet weak var lblRecordingTime: UILabel!
    @IBOutlet weak var recordingView: AudioVisualizationView!
    @IBOutlet weak var lblTime: UILabel!
    
    //MARK:- Veriables
    private let viewModel = ViewModel()
    private var chronometer: Chronometer?
    var totalSec:Double = 0.0
    var timer = Timer()
    var array = [Float]()
    
    private var currentState: AudioRecodingState = .ready {
        didSet {
            /*
            self.recordButton.setImage(self.currentState.buttonImage, for: .normal)
            self.audioVisualizationView.audioVisualizationMode = self.currentState.audioVisualizationMode
            self.clearButton.isHidden = self.currentState == .ready || self.currentState == .playing || self.currentState == .recording
            */
        }
    }

    
    //MARK:- Actions
    @IBAction func actionRecording(_ sender: Any) {
        if self.currentState == .recording{
            self.chronometer?.stop()
            self.chronometer = nil
            self.recordingView.audioVisualizationMode = .read
            do {
                try self.viewModel.stopRecording()
                self.timer.invalidate()
                self.currentState = .recorded
                self.recordingView.audioVisualizationMode = .read
                self.recordingView.meteringLevels = array
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                    let vc = self.storyboard?.instantiateViewController(identifier: "UploadViewController") as! UploadViewController
                    vc.array = self.array
                    vc.length = self.lblTime.text ?? "00:00"
                    do{
                        let path = "file://\(self.viewModel.currentAudioRecord?.audioFilePathLocal?.absoluteURL.absoluteString ?? "")"
                        if let data = URL(string: path){
                            let mp3 = podcastRecordingViewController.getURL()
                            AudioRecorderManager.convertAudio(data, outputURL: mp3)
                            let audio = try Data(contentsOf: mp3)
                            vc.audio = audio
                        }
                    }catch{
                        
                    }
                    vc.sceonds = Int(self.totalSec)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            } catch {
                self.currentState = .ready
            }
        } else if self.currentState == .ready {
            self.viewModel.startRecording { [weak self] soundRecord, error in
                if let error = error {
//                    self?.showAlert(with: error)
                    return
                }
                self?.recordingView.audioVisualizationMode = .write
                self?.currentState = .recording
                self?.chronometer = Chronometer()
                self?.chronometer?.start()
                self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self?.updateCounting), userInfo: nil, repeats: true)
            }
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Global.shared.universalPlayer?.alpha = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        Global.shared.universalPlayer?.alpha = 1
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    class func getURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("file.mp3")
    }
    func config(){
        self.viewModel.askAudioRecordingPermission()
        self.recordingView.gradientStartColor = .geeniColor
        self.recordingView.gradientEndColor = .geeniColor
        self.recordingView.meteringLevelBarWidth = 2.0
        self.viewModel.audioMeteringLevelUpdate = { meteringLevel in
            guard self.recordingView.audioVisualizationMode == .write else {
                return
            }
            self.recordingView.add(meteringLevel: meteringLevel)
            self.array.append(meteringLevel)
        }
        self.viewModel.audioDidFinish = { [weak self] in
            self?.currentState = .recorded
            self?.recordingView.stop()
        }
        
    }
    @objc func updateCounting(){
        totalSec += 1
        lblTime.text = totalSec.stringFromTimeInterval()
    }
}
enum AudioRecodingState {
    case ready
    case recording
    case recorded
    case playing
    case paused

    var buttonImage: UIImage {
        switch self {
        case .ready, .recording:
            return #imageLiteral(resourceName: "Record-Button")
        case .recorded, .paused:
            return #imageLiteral(resourceName: "Play-Button")
        case .playing:
            return #imageLiteral(resourceName: "Pause-Button")
        }
    }

    var audioVisualizationMode: AudioVisualizationView.AudioVisualizationMode {
        switch self {
        case .ready, .recording:
            return .write
        case .paused, .playing, .recorded:
            return .read
        }
    }
}

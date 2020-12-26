//
//  UploadViewController.swift
//  pdm
//
//  Created by Muhammad Aqeel on 25/12/2020.
//

import UIKit
import SoundWave
import Alamofire
import Photos
import AVFoundation

class UploadViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var recordingView: AudioVisualizationView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblImage: UILabel!
    
    @IBOutlet weak var tfPodcastName: UITextFieldX!
    @IBOutlet weak var tfEpisodeName: UITextFieldX!
    @IBOutlet weak var tfAuthor: UITextFieldX!
    @IBOutlet weak var tfDescription: UITextFieldX!
    
    @IBOutlet weak var collectionCat: UICollectionView!
    
    //MARK:- Action
    @IBAction func actionPickImage(_ sender: Any) {
        getImage()
    }
    @IBAction func actionUploadToPDM(_ sender: Any) {
        if isValid(){
            let params:[String:Any] = [
                "duration":String(sceonds),
                "episode_name":tfEpisodeName.text ?? "",
                "author":tfAuthor.text ?? "",
                "episode_description":tfDescription.text ?? "",
                "user_podcast_exist":"0",
                "podcast":tfPodcastName.text ?? "",
                "category":String(selectedCategory)
            ]
            let file:[String:Data] = ["podcast_icon":imageData!,"file":audio!]
            WebManager.getInstance(delegate: self)?.uploadPodcast(parms: params, file: file)
        }
    }
    
    //MARK:- Veriable
    var array = [Float]()
    var audio:Data?
    var length = "00:00"
    var sceonds:Int = 0
    var categories = [Categorys]()
    var imageData:Data?
    var selectdIndex = -1
    var selectedCategory = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    func config(){
        self.recordingView.gradientStartColor = .greenColor
        self.recordingView.gradientEndColor = .greenColor
        self.recordingView.meteringLevelBarWidth = 2.0
        self.recordingView.audioVisualizationMode = .read
        self.recordingView.meteringLevels = array
        lblTime.text = length
        register()
        WebManager.getInstance(delegate: self)?.getCategoriesData()
    }
}

//MARK:- Collection
extension UploadViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func register(){
        collectionCat.register(UINib(nibName: "SmallCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SmallCategoryCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionCat.dequeueReusableCell(withReuseIdentifier: "SmallCategoryCell", for: indexPath) as! SmallCategoryCell
        let category = categories[indexPath.row]
        var isSelected = false
        if indexPath.row == selectdIndex{
            isSelected = true
        }
        cell.config(categories: category, width: 200, isSeleted: isSelected)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectdIndex = indexPath.row
        selectedCategory = categories[indexPath.row].id ?? 0
        self.collectionCat.reloadData()
    }
}

//MARK:- Api
extension UploadViewController: WebManagerDelegate{
    func failureResponse(response: AFDataResponse<Any>) {
        Utility.showAlertWithSingleOption(controller: self, title: kEmpty, message: kCannotConnect, preferredStyle: .alert, buttonText: kok, buttonHandler: nil)
    }
    
    func networkFailureAction() {
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
                let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    if let searchResult:SearchModel = self.handleResponse(data: jsonData){
                        if let listCat = searchResult.data.categories{
                            categories = listCat
                        }
                    } else if(successresponse as! Bool == true){
                        Utility.showAlertWithSingleOption(controller: self, title: "Success", message: (result.object(forKey: "message") as? String) ?? "Opertation Successfull", preferredStyle: .alert, buttonText: "OK", buttonHandler: {_ in
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self.collectionCat.reloadData()
            }
            
            break
        case .failure(_):
            let alert = UIAlertController(title: "Error", message: "Please enter correct username and password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
}
//MARK:- Camera
extension UploadViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func getImage(){
        let bottomSheet = BotttomSheetHelper()
        bottomSheet.showAttachmentActionSheet(vc: self)
        bottomSheet.callBack = { type in
            self.handlePicker(type: type)
        }
    }
    func handlePicker(type:PhotoMediaType){
        switch type {
        case .camera:
            handleCamera()
        case .gallery:
            handleGallery()
        }
    }
    func handleCamera(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status{
        case .authorized:
            self.openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera()
                }
            }
        case .denied, .restricted:
            //self.addAlertForSettings(attachmentTypeEnum)
            return
            
        default:
            break
        }
    }
    func handleGallery(){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status{
        case .authorized:
            photoLibrary()
        case .denied, .restricted: break
            //self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    self.photoLibrary()
                }
            })
        default:
            return
        }
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            DispatchQueue.main.async {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                self.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            DispatchQueue.main.async {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        let chosenImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
        let data = chosenImage.jpegData(compressionQuality: 1)
        ivImage.image = UIImage(data: data ?? Data())
        imageData = data ?? Data()
        viewImage.alpha = 0
        lblImage.alpha = 0
    }
}

//MARK:- Validation
extension UploadViewController{
    func isValid() -> Bool{
        guard let _ = imageData else {
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Image is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfPodcastName.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Podcast Name is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfEpisodeName.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Episode Name is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfAuthor.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Author Name is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        if tfDescription.text?.isEmpty ?? true{
            Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Description is Required", preferredStyle: .alert, buttonText: "OK")
            return false
        }
        return true
    }
}

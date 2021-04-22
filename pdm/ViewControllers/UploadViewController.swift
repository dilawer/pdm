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
        print("Working = \(isPodcastUploaded)")
//        guard !isPodcastUploaded else {
//            return
//        }
        getImage()
    }
    @IBAction func actionUploadToPDM(_ sender: Any) {
        print("actionUploadToPDM global = \(Global.shared.userPodcastCategory), selected = \(String(selectedCategory))")
        if isValid(){
//            selectedCategoryArray.removeAll()
//            for cat in categoriesArray {
//                selectedCategoryArray.append(String(cat))
//            }
            let podcastID = Global.shared.userPodcastID
            let params:[String:Any] = [
                "duration":String(sceonds),
                "episode_name":tfEpisodeName.text ?? "",
                "author":tfAuthor.text ?? "",
                "episode_description":tfDescription.text ?? "",
                "user_podcast_exist":podcastID == nil ? "0" : "1",
                "podcast":podcastID == nil ? (tfPodcastName.text ?? "") : (podcastID ?? "0"),
                "category":selectedCategoryArray.description//podcastID == nil ? (String(selectedCategory)) : (Global.shared.userPodcastCategory)
                //"category":podcastID == nil ? "1" : "2"

            ]
            print("actionUploadToPDM params = \(params)")
            var file = [String:Data]()
            if imageData != nil {
                file = ["podcast_icon":imageData ?? Data(),"file":audio ?? Data()]
            }else{
                if !isPodcastUploaded{
                    file = ["podcast_icon":imageData ?? Data(), "file":audio ?? Data()]
                }else{
                    file = ["file":audio ?? Data()]
                }
            }
//            if !isPodcastUploaded{
                
//            } else {
//                file = ["podcast_icon":imageData ?? Data(),"file":audio ?? Data()]
//            }
            print("actionUploadToPDM file = \(file)")
            WebManager.getInstance(delegate: self)?.uploadPodcast(parms: params, file: file)
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        Utility.showAlertWithOptions(controller: self, title: "Are You Sure To Go Back?", message: "Your Curent Recording Will Lost", preferredStyle: .alert, rightBtnText: "Yes", leftBtnText: "No",leftBtnhandler: {
            _ in
        },rightBtnhandler: {
            _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    //MARK:- Veriable
    var array = [Float]()
//    var categoriesArray = [Int]()
    var selectedCategoryArray = [Int]()
//    var categoriesIndexArray = [Int]()
    var audio:Data?
    var length = "00:00:00"
    var sceonds:Int = 0
    var categories = [Categorys]()
    var imageData:Data?
    var selectdIndex = -1
    var selectedCategory = -1
    var isPodcastUploaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    func config(){
        self.recordingView.gradientStartColor = .geeniColor
        self.recordingView.gradientEndColor = .geeniColor
        self.recordingView.meteringLevelBarWidth = 2.0
        self.recordingView.audioVisualizationMode = .read
        self.recordingView.meteringLevels = array
        lblTime.text = length
        register()
        WebManager.getInstance(delegate: self)?.getCategoriesData()
        if let _ = Global.shared.userPodcastID{
            isPodcastUploaded = true
            ImageLoader.loadImage(imageView: ivImage, url: Global.shared.userPodcastImageLink)
            tfPodcastName.text = Global.shared.userPodcastName
            tfPodcastName.alpha = 0.5
            tfPodcastName.isUserInteractionEnabled = false
            self.selectedCategoryArray = Global.shared.userPodcastCategories
//            for (index,i) in categories.enumerated(){
//                if String(i.id ?? -1) == Global.shared.userPodcastCategory {
//                    selectdIndex = index
//                    collectionCat.reloadData()
//                    break
//                }
//            }
            viewImage.alpha = 0
            lblImage.alpha = 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Global.shared.universalPlayer?.alpha = 0
        print("Global.shared.userPodcastCategory = \(Global.shared.userPodcastCategory)")
    }
    override func viewWillDisappear(_ animated: Bool) {
        Global.shared.universalPlayer?.alpha = 1
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
            Global.shared.universalPlayer?.alpha = 0
        })
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

//        var isSelected = false
//        if indexPath.row == selectdIndex{
//            isSelected = true
//        }
        if selectedCategoryArray.contains(category.id!) {
            cell.catSelected = true
        }
        else {
            cell.catSelected = false
        }
        cell.config(categories: category, width: 200, isSeleted: cell.catSelected)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryID = categories[indexPath.row].id
        if selectedCategoryArray.contains(categoryID!) {
            selectedCategoryArray.remove(at: selectedCategoryArray.firstIndex(of: categoryID!)!)
            
        }else{
            selectedCategoryArray.append(categoryID!)
        }
        
//        if categoriesIndexArray.contains(indexPath.row) {
//            let index = categoriesIndexArray.index(of: indexPath.row)
//            categoriesIndexArray.remove(at: index ?? 0)
//
//            let catIndex = categoriesArray.index(of: indexPath.row)
//            categoriesArray.remove(at: catIndex ?? 0)
//
//        }
//        else {
//            categoriesIndexArray.append(indexPath.row)
//            categoriesArray.append(categories[indexPath.row].id ?? 0)
//        }
        
        UIView.setAnimationsEnabled(false)
        let selectedCell = collectionView.cellForItem(at: indexPath)
        let visibleRect = collectionView.convert(collectionView.bounds, to: selectedCell)

//        selectedObjects.insert(allObjects[indexPath.item], at: 0)
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [indexPath])
        }) { (finished) in
            collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        }
        UIView.setAnimationsEnabled(true)
        
        
//        [myCollectionView reloadItemsAtIndexPaths:[myCollectionView indexPathsForVisibleItems]];
//        let cell = collectionCat.dequeueReusableCell(withReuseIdentifier: "SmallCategoryCell", for: indexPath) as! SmallCategoryCell
//        if categoriesIndexArray.contains(indexPath.row) {
//            cell.catSelected = true
//        }
//        else {
//            cell.catSelected = false
//        }

        
        
//        let selectedCell = collectionView.cellForItem(at: indexPath) as! SmallCategoryCell
//        if categoriesIndexArray.contains(indexPath.row) {
//            selectedCell.catSelected = true
//        }
//        else {
//            selectedCell.catSelected = false
//        }
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
            print("result = \(result)")
             
            let successresponse = result.object(forKey: "success")
            if successresponse != nil {
                if(successresponse as! Bool == false) {
                    let alert = UIAlertController(title: "Error", message: (result.object(forKey: "message")! as! String), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                        if let searchResult:SearchModel = self.handleResponse(data: jsonData){
                            if let listCat = searchResult.data.categories{
//                                if self.isPodcastUploaded{
//                                    for (index,i) in listCat.enumerated(){
//                                        if String(i.id ?? -1) == Global.shared.userPodcastCategory {
//                                            selectdIndex = 0
//                                            categories.append(i)
//                                            collectionCat.reloadData()
//                                            break
//                                        }
//                                    }
//                                }else {
                                    categories = listCat
                                    collectionCat.reloadData()

//                                }
                            }
                        } else if(successresponse as! Bool == true){
                            if let msg = result.object(forKey: "message") as? String , msg.contains("successfull"){
                                Utility.showAlertWithSingleOption(controller: self, title: "Congratulations!", message: "Your Podcast has been submitted to  PDM for review. We will notify you on approvals.", preferredStyle: .alert, buttonText: "Continue to PDM", buttonHandler: {_ in
                                    self.navigationController?.popToRootViewController(animated: true)
                                    Global.shared.Home?.refersh()
                                })
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.collectionCat.reloadData()
                }
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
        if !isPodcastUploaded{
            guard let _ = imageData else {
                Utility.showAlertWithSingleOption(controller: self, title: "Error", message: "Image is Required", preferredStyle: .alert, buttonText: "OK")
                return false
            }
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

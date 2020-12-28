//
//  Web Manager.swift
//  Carigo
//
//  Created by Maaz Butt on 9/12/18.
//  Copyright © 2018 Muhammad Ahsan Ayyaz. All rights reserved.
//

import Foundation
import Alamofire
import AVFoundation
import SVProgressHUD

protocol WebManagerDelegate {
    func successResponse(response: AFDataResponse<Any>, webManager: WebManager)
    func failureResponse(response: AFDataResponse<Any>)
    func networkFailureAction()
}
extension WebManagerDelegate {
    
    func progressResponse(response: Progress, webManager: WebManager) {
        //this is a empty implementation to allow this method to be optional
    }
}

class WebManager: NSObject {
    let delegate: WebManagerDelegate
    var sessionCount = 0
    var changePass = false
    var isDiscount = false
    var isLoginForNewSession = false
    var isUpdateProfileImage = false
    var isUpdateProfileData = false
    var isOrderNow = false
    var isOrderLater = false
    var isReLoginForNewSession = false
    var isCourierCompanyList = false
    var isDirectionApi = false
    var isFindDriver = false
    var isRating = false
    var isAverageRating = false
    var isDriverCarrier = false
    var isDropOffImage = false
    var isEstimatedFare = false
    var isSpecificOrder = false
    var isReOrder = false
    var isOrders = false
    var isCustomerAd = false
    var isCancelOrder = false
    var isMobileCode = false
    var isConfirmCode = false
    var destinationIndex = 0
    var isFetchCategories = false
    var isFBLogin = false
    var isDirectionApi1 = false
    // MARK: init methods
    init(d: WebManagerDelegate) {
        self.delegate = d
    }
    
    class func getInstance(delegate: WebManagerDelegate) -> WebManager? {
        return WebManager(d: delegate)
    }
    
    //MARK: homeData
    func getHomeData() {
        let params = [:] as [String : Any]
        let url = "\(kbaseURL)\(khome)"
        makeRequest(requestUrl: url, method: .get, parameters: params)
    }
    func getHomeTrendingData() {
        let params = [:] as [String : Any]
        let url = "\(kbaseURL)\(khome_mic)"
        makeRequest(requestUrl: url, method: .get, parameters: params)
    }
    func getSelectedPodcast(selected: String) {
        let params = [:] as [String : Any]
        let url = "\(kbaseURL)\(kpodcast_selected)\(selected)"
        makeRequest(requestUrl: url, method: .get, parameters: params)
    }
    func getProfileDetail() {
        let params = [:] as [String : Any]
        let url = "\(kbaseURL)\(kprofile_detail)"
        makeRequest(requestUrl: url, method: .get, parameters: params)
    }
    func getCategoriesData() {
        let params = [:] as [String : Any]
        let url = "\(kbaseURL)\(khome_categories)"
        makeRequest(requestUrl: url, method: .get, parameters: params)
    }
    func getPodcastsForCategory(cat_id:String){
        let url = "\(kbaseURL)\(kPodcastsForCat)\(cat_id)"
        makeRequest(requestUrl: url, method: .get, parameters: nil)
    }
    func getPodcastDetails(podCast_id:String){
        //detail/1
        let url = "\(kbaseURL)\(kPodCastDetails)\(podCast_id)"
        makeRequest(requestUrl: url, method: .get, parameters: nil)
    }
    
    //MARK: authentication
    func signInWithEmail(email: String, pass: String, type: LoginType) {
        let params = [kusername: email, kpassword: pass, kis_email: type.rawValue] as [String : Any]
        let url = "\(kbaseURL)\(klogin)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    func signUp(name: String, email: String, pass: String, confirmPass: String, fullName: String, dob: String) {
        let params = [kUserName: name, kemail: email, kpassword: pass, kconfirmPassword: confirmPass, kfullName: fullName, kdob: dob] as [String : Any]
        let url = "\(kbaseURL)\(kregister)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    func forgotUsername(email: String) {
        let params = [kemail: email] as [String : Any]
        let url = "\(kbaseURL)\(kforgot_username)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    func forgotPassword(email: String){
        let params = [kemail: email] as [String : Any]
        let url = "\(kbaseURL)\(kforgot_username)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    func resetPassword(parms:[String:Any]){
        let url = "\(kbaseURL)\(kResetPassword)"
        makeRequest(requestUrl: url, method: .post, parameters: parms)
    }
    func socialLogin(provider:String,email:String,id:String,given_name:String,family_name:String){
        let params = ["provider": provider,"email":email, "id":id,"given_name":given_name,"family_name":family_name] as [String : Any]
        let url = "\(kbaseURL)\(kSocialLogin)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    func getPdmHistory(){
        let url = "\(kbaseURL)\(kUploadHistory)"
        makeRequest(requestUrl: url, method: .get, parameters: nil)
    }
    func uploadPodcast(parms:[String : Any],file:[String : Data]){
        let url = "\(kbaseURL)\(kUploadPodcast)"
        makeRequest(requestUrl: url, isMultipart: true, fileArray: file, method: .post, parameters: parms)
    }
    func getLikedPodcasts(){
        let url = "\(kbaseURL)\(kLikedPodcasts)"
        makeRequest(requestUrl: url)
    }
    func LikePodcast(parms:[String:Any]){
        let url = "\(kbaseURL)\(kLikePodcast)"
        makeRequest(requestUrl: url, method: .post, parameters: parms)
    }
    
    
    //MARK:- Search
    func search(query:String){
        let url = "\(kbaseURL)\(kSearch)\(query)"
        makeRequest(requestUrl: url, method: .get, parameters: nil)
    }
    
    func downloadImage(imageUrl: String, imageView: UIImageView) {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(imageUrl.subStringAfterLastslash)

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(imageUrl, to: destination).response { response in
            debugPrint(response)

            if response.error == nil, let imagePath = response.fileURL?.path {
                imageView.image = UIImage(contentsOfFile: imagePath)
            }
        }
    }
    

    //MARK: helper method
    func makeRequest(requestUrl: String,isMultipart:Bool = false,fileArray:[String:Data]? = nil , method: HTTPMethod = .get, parameters: Parameters? = nil) {
        let retryCount = 3
        if Utility.isInternetConnected() {
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            var headers: HTTPHeaders = []
            if User.getInstance()?.isLogin == true {
                headers = [
                    "Authorization": "Bearer \(User.getInstance()?.access_token ?? "")",
                    "Content-Type": "application/x-www-form-urlencoded",
                    "Accept": "application/json"
                ]
            }
            
            if isMultipart{
                AF.upload(multipartFormData: { multipartFormData in
                    if let _ = parameters{
                        for (key,value) in parameters.unsafelyUnwrapped{
                            multipartFormData.append((value as? String ?? "").data(using: .utf8) ?? Data(), withName: key)
                        }
                    }
                    if let files = fileArray{
                        for(key,value) in files{
                            var value = value
                            if let img = UIImage(data: value){
                                value = img.jpegData(compressionQuality: 0.7) ?? Data()
                                multipartFormData.append(value, withName: key, fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/jpeg")
                            }else {
                                multipartFormData.append(value, withName: key, fileName: "\(Date().timeIntervalSince1970).mp3", mimeType: "audio/mp3")
                            }
                        }
                    }
                }, to: requestUrl,headers: headers).responseJSON{ response in
                    switch (response.result) {
                    case .success(_):
                        SVProgressHUD.dismiss()
                        self.delegate.successResponse(response: response,webManager: self)
                        break
                    case .failure(_):
                        SVProgressHUD.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.retryRequest(requestUrl: requestUrl, retryCount:retryCount)
                        })
                        break
                    }
                }
                return
            }
            
            AF.request(requestUrl, method: method, parameters: parameters, headers: headers)
            .responseJSON { response in
                switch (response.result) {
                case .success(_):
                    SVProgressHUD.dismiss()
                    self.delegate.successResponse(response: response,webManager: self)
                    break
                case .failure(_):
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.retryRequest(requestUrl: requestUrl, retryCount:retryCount)
                    })
                    break
                }
            }
        } else {
            self.delegate.networkFailureAction()
        }
    }
    
    
    func retryRequest(requestUrl: String, retryCount: Int)
    {
        if Utility.isInternetConnected() {
            AF.request(requestUrl)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    self.delegate.successResponse(response: response,webManager: self)
                    break
                case .failure(_):
                    print(retryCount)
                    if(retryCount >= 0)
                    {
                        self.retryRequest(requestUrl: requestUrl, retryCount:retryCount - 1)
                    }
                    else{
                        self.delegate.failureResponse(response: response)
                    }
                    break
                }
            }
        } else {
            self.delegate.networkFailureAction()            
        }
    }
}

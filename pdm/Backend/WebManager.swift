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
    func socialLogin(provider:String,access_token:String,email:String){
        let params = ["provider": provider, "access_token":access_token,"email":email] as [String : Any]
        let url = "\(kbaseURL)\(kforgot_username)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
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
    func makeRequest(requestUrl: String, method: HTTPMethod = .get, parameters: Parameters? = nil) {
        let retryCount = 3
        if Utility.isInternetConnected() {
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            var headers: HTTPHeaders = []
            if User.getInstance()?.isLogin == true {
                headers = [
                    "Authorization": "Bearer \(User.getInstance()?.access_token ?? "")",
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
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

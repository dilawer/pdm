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
    
    
    //MARK: authentication
    func signInWithEmail(email: String, pass: String) {
        let params = [kusername: email, kpassword: pass, kis_email: "2"] as [String : Any]
        let url = "\(kbaseURL)\(klogin)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }

    //MARK: helper method
    func makeRequest(requestUrl: String, method: HTTPMethod = .get, parameters: Parameters? = nil) {
        let retryCount = 3
        if Utility.isInternetConnected() {
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
                    self.delegate.successResponse(response: response,webManager: self)
                    break
                case .failure(_):
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

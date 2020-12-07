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
    //func successResponse(response: DataResponse<Any, .success>, webManager: WebManager)
    //func failureResponse(response: DataResponse<Any>)
    func networkFailureAction()
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
    
    func direction1(origin: String, destination: String) {
        let url = "\(kDirectionAPIOrigin)\(origin)\(kDirectionAPIDestination)\(destination)\(kDirectionAPIkey)\(kGMS_APIKEY)"
        print(url)
        self.isDirectionApi1 = true
        makeRequest(requestUrl: url, method: .get, parameters: nil)
    }
    
    func direction(origin: String, destination: String) {
        let url = "\(kDirectionAPIOrigin)\(origin)\(kDirectionAPIDestination)\(destination)\(kDirectionAPIkey)\(kGMS_APIKEY)"
        print(url)
        self.isDirectionApi = true
        makeRequest(requestUrl: url, method: .get, parameters: nil)
    }
    
    func signUpWithFacebookApiData(id: String, email: String, name: String, token: String, imageUrl: String){
        isFBLogin = true
        let url = kFbUrl
        let params = ["user_id": id , "name": name , "email": email , "profile_pic": imageUrl , "access_token": token]
        print(params)
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func signUpWithFacebook(id: String, email: String, name: String) {
        let url = "\(kbaseURL)\(kSigninWithFacebook)"
        let params = [kfbToken: id, kfullName: name, kemail: email]
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func getMobileCode(mobileNumber: String, countryCode: String) {
        isMobileCode = true
        let params = [kMOBILE: mobileNumber, kCountry_Code: countryCode]
        let url = "\(kbaseURL)\(kMobileCode)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func confirmCode(mobileNumber: String, verificationCode : String, countryCode: String) {
        isConfirmCode = true
        let params = [kMOBILE: mobileNumber, kVerificationCode: verificationCode, kCountry_Code: countryCode]
        let url = "\(kbaseURL)\(kconfirm_mobile)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func getCourierCompany() {
        self.isCourierCompanyList = true
        let url = "\(kbaseURL)\(kGetCourierCompanies)"
        makeRequest(requestUrl: url, method: .get)
    }
    
    func getAverageRating(apiKey : String) {
        self.isAverageRating = true
        let params = [kapiKey: apiKey]
        let url = "\(kbaseURL)\(kaverage_rating)"
        makeRequest(requestUrl: url, method: .post, parameters: params )
    }
    
    func getSpecificOrder(apiKey : String, orderID : String, status : String) {
        self.isSpecificOrder = true
        let params = [kapiKey: apiKey, korder_id : orderID, kstatus : status]
        let url = "\(kbaseURL)\(kget_specific_order)"
        makeRequest(requestUrl: url, method: .post, parameters: params )
    }
    
    func checkDiscountAvailability(apiKey : String) {
        self.isDiscount = true
        let params = [kapiKey: apiKey]
        let url = "\(kbaseURL)\(kcheck_discount)"
        makeRequest(requestUrl: url, method: .post, parameters: params )
    }
    
    
    
    
    func getDriverCarriers(apiKey : String){
        self.isDriverCarrier = true
        let url = "\(kbaseURL)\(kDriver_carriers)"
        let params = [kapiKey : apiKey]
        print(url)
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    
    func paymentDone(apiKey : String, transactionId : String, callBack : String, driver_ID: String) {
        let url = "http://carigologistics.com/Pay_bill"
        let params = [kapiKey: apiKey, "transection_id": transactionId, "callback": callBack, "driverid": driver_ID]
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }

    func getRatings(apiKey : String, orderID : String, rateValue : String, rateComment : String, skipEvaluation: String){
        isRating = true
        let url = "\(kbaseURL)\(kuser_order_ratings)"
        let params = [kapiKey : apiKey ,korder_id : orderID, krate_value : rateValue, krate_comment : rateComment, kskiped_value : skipEvaluation]
        print(url)
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func updateProfileData(name: String, email: String, apiKey: String, mobile: String, countryCode: String) {
        let params = [kfullName: name, kemail: email, kapiKey: apiKey, kmobileNumber: mobile, kCountry_Code: countryCode]
        let url = "\(kbaseURL)\(kProfileInfo)"
        self.isUpdateProfileData = true
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func updateProfileData1(name: String, email: String, apiKey: String) {
        let params = [kfullName: name, kemail: email, kapiKey: apiKey]
        let url = "\(kbaseURL)\(kProfileInfo)"
        self.isUpdateProfileData = true
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func getOrders(apiKey: String, status: String) {
        isOrders = true
        let params = [kapiKey: apiKey, kstatus: status]
        let url = "\(kbaseURL)\(kget_orders)"
        print(url)
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func getFCMToken(apiKey: String, token: String, platform : String) {
        isOrders = true
        let params = [kapiKey: apiKey, kFCMToken: token, kplatform : platform]
        let url = "\(kbaseURL)\(kupdateFCMToken)"
        print(url)
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }

    
    func customerLogout(apiKey: String) {
        isOrders = true
        let params = [kapiKey: apiKey]
        let url = "\(kbaseURL)\(klogout)"
        print(url)
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    //MARK: Items(image/video) uploaded method
//    func uploadProfileImage(data: Data, parameters: Parameters) {
//        self.isUpdateProfileImage = true
//        let URL = try! URLRequest(url: "\(kbaseURL)\(kUpdateProfilePicture)", method: .post)
//            Alamofire.upload(multipartFormData: { multipartFormData in
//                    multipartFormData.append(data, withName: kphoto, fileName: "\(kphoto).png", mimeType: "image/png")
//                if parameters != nil {
//                    let api_key = ((parameters[kapiKey])! as! String).data(using: String.Encoding.utf8)
//                    multipartFormData.append(api_key!, withName: kapiKey)
//                }
//            }, with: URL, encodingCompletion: { result in
//                switch result {
//                case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { Progress in
//                        print("UPLOAD PROGRESS: \(Progress.fractionCompleted * 100)")
//                    })
//                    upload.responseJSON { response in
//                        self.delegate.successResponse(response: response, webManager: self)
//                    }
//                case .failure(let response):
//                    print(response)
//                    self.delegate.failureResponse(response: response as! DataResponse<Any>)
//                }
//            })
//    }
    func currentTimeInMilliSeconds() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
//    func getPreOrder(apiKey: String, userId: String, filter: String) {
//        let params = [kapiKey: apiKey, kuserID: userId, kFilter: filter]
//        let url = "\(kbaseURL)\(kget_orders)"
//        makeRequest(requestUrl: url, method: .get, parameters: params)
//    }
//
//    func getCompleteOrder(apiKey: String, userId: String, filter: String) {
//        let params = [kapiKey: apiKey, kuserID: userId, kFilter: filter]
//        let url = "\(kbaseURL)\(kget_orders)"
//        makeRequest(requestUrl: url, method: .get, parameters: params)
//    }
    
    func changePass(apiKey: String, oldPass: String, newPass: String) {
        changePass = true
        let params = [kapiKey: apiKey, kOldPassword: oldPass, kNewPassword: newPass]
        let url = "\(kbaseURL)\(kChangePassword)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func getEstimations() {
        let url = "\(kbaseURL)\(kGetEstimation)"
        makeRequest(requestUrl: url)
    }
    
    func scheduleOrder(params: [String : Any]) {
        let url = "\(kbaseURL)\(kpre_booking_order)"
        self.isOrderLater = true
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func orderStatus(apiKey: String, userId: String, orderId: String) {
        let params = [kapiKey: apiKey, kuserID: userId, korderID: orderId]
        let url = "\(kbaseURL)\(kGetOrderStatus)"
        makeRequest(requestUrl: url, method: .get, parameters: params)
    }
    
    func getCustomerAd() {
        self.isCustomerAd = true
        let url = "\(kbaseURL)\(kget_customer_ads)"
        makeRequest(requestUrl: url, method: .get)
    }
   
    func orderNow(params: [String : Any]) {
        //Do, try , catch
        do {
            //this is your json data as NSData that will be your payload for your REST HTTP call.
            let JSONPayload: NSData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            
            //This is unnecessary, but I'm echo-checking the data from the step above.  You don't need to do this in production.  Just to see the JSON in native format.
            let JSONString = NSString(data: JSONPayload as Data, encoding: String.Encoding.utf8.rawValue)! as String
            print("\(JSONString)")
            
            //From here you should carry on with your task or assign JSONPayload to a varialble outside of this block
        } catch {//catch errors thrown by the NSJSONSerialization.dataWithJSONObject func above.
            let err = error as NSError
            NSLog("\(err.localizedDescription)")
        }

        
        
        
//        let jsonEncoder = JSONEncoder()
//        let jsonData = try jsonEncoder.encode(params)
//        let json = String(data: jsonData, encoding: String.Encoding.utf16)

        
        
        let url = "\(kbaseURL)\(kPlaceOrderNow)"
        self.isOrderNow = true
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func estimateFare(params: [String : Any]) {
        let url = "\(kbaseURL)\(kestimated_fare)"
        self.isEstimatedFare = true
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }

    
    
    func loginIn(email:String, password:String) {
        let url = "\(kbaseURL)\(kLoginWithEmail)"
        let params = [kemail: email, kpassword: password]
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func signUp(name: String, userName: String, pass: String) {
        let params = [kfullName: name, kemail: userName, kpassword: pass]
        let url = "\(kbaseURL)\(kSignUpwithEmail)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func fetchCategories(apiKey: String) {
        isFetchCategories = true
        let params = [kapiKey: apiKey]
        let url = "\(kFetchCategoriesURL)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    func fcmNotifcations(apiKey: String, fcmToken: String) {
        let params = [kapiKey: apiKey, kFcmToken: fcmToken]
        let url = "\(kFcmTokenUrl)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func forgetPassword(email: String) {
        let params = [kemail: email]
        let url = "\(kbaseURL)\(kForgetPassword)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func findDriver(apiKey: String, orderID: String) {
        //dilawer
        let params = [kapiKey: apiKey, korderID: orderID]
        let url = "\(kbaseURL)\(kfind_driver)"
        self.isFindDriver = true
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    func cancelOrder(apiKey: String, orderID: String) {
        isCancelOrder = true
        let params = [kapiKey: apiKey, korderID: orderID] as [String : Any]
        let url = "\(kbaseURL)\(kUserCancelOrder)"
        makeRequest(requestUrl: url, method: .post, parameters: params)
    }
    
    
    func downloadColors(contentID: String){
      // 1.
      AF.request("http://api.imagga.com/v1/colors",
                        parameters: ["content": contentID])
        .responseJSON { response in
          // 2
          
      }
    }
    

    //MARK: helper method
    func makeRequest(requestUrl: String, method: HTTPMethod = .get, parameters: Parameters? = nil) {
//        let jsonData = try? JSONSerialization.data(withJSONObject: aDictParam, options: [])
//        var jsonString = String(data: jsonData!, encoding: .utf8)
//        jsonString = jsonString!.filter { !"\\)(\n\t\r".contains($0) }
//
//        let passingParameter = [K_APIKEY:APIKEY, K_Data:jsonString!]
//        Alamofire.request(requestUrl, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.default, headers: ["Content-Type" :"application/json"]).responseJSON { (response:DataResponse<Any>) in
//                switch(response.result) {
//                case .success(_):
//                    completeBlock(response.result.value as AnyObject)
//                    break
//
//                case .failure(let error):
//                    var errorDict = [String : Any]()
//                    let errorcode : Int = error._code
//                    if let httpStatusCode = response.response?.statusCode {
//                        switch(httpStatusCode) {
//                        case 404:
//                            errorDict = ["errormsg" : "Invalid URL: \(passingURL)", "errorCode" : httpStatusCode]
//                        default: break
//
//                        }
//                    } else {
//                        if (String(errorcode) == "-1009"){
//                            errorDict = ["errormsg" : "Please check your internet connection"]
//                        }
//                        else if(error.localizedDescription != ""){
//                            errorDict = ["errormsg" : error.localizedDescription]
//                        }
//                        else{
//                            errorDict = ["errormsg" : "Server unreachable please try again later."]
//                        }
//                    }
//                    errorBlock(errorDict as AnyObject)
//                    break
//                }
//            }
//        let retryCount = 3
//        Alamofire.request (requestUrl, method: method, parameters: parameters ).responseJSON { (response: DataResponse<Any>) in
//            switch (response.result) {
//            case .success(_):
//                self.delegate.successResponse(response: response, webManager: self)
//                break
//            case .failure(_):
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                    self.retryRequest(requestUrl: requestUrl, retryCount:retryCount)
//                })
//                break
//            }
//        }
    }
    
    func retryRequest(requestUrl: String, retryCount: Int) {
        //Alamofire.req
//        Alamofire.request(requestUrl).responseJSON { (response: DataResponse) in
//            switch(response.result) {
//            case .success(_):
//                self.delegate.successResponse(response: response, webManager: self)
//                break
//            case .failure(_):
//                print(retryCount)
////                    if(retryCount >= 0) {
////                        self.retryRequest(requestUrl: requestUrl, retryCount:retryCount - 1)
////                    } else {
//                    self.delegate.failureResponse(response: response)
////                    }
//                break
//            }
//        }
    }
}

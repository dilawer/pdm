//
//  UserInfo.swift
//
//  Created by Dilawer Hussain on 12/10/20.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

import UIKit

let kuserid = "userid"
let kuserName = "userName"
// remove them later
let kname = "name"
let kprofile = "profile"
let kcover = "cover"

//
let kfullName = "fullName"
let kemail = "email"
let kdob = "dob"
let kcreatedAt = "createdAt"
let kupdatedAt = "updatedAt"
let kprofile_image = "profileImage"
let kautoplay = "autoplay"
let kcover_image = "coverImage"
let kaccess_token = "access_token"
let kisLogin = "isLogin"
let ktotalListens = "totalListens"
let ktotalMinutes = "totalMinutes"
let kuploadedPods = "uploadedPods"
let ktotalLiked = "totalLiked"
let kUserName = "name"


let k_user = "user"
let ktoken = "token"


class User: NSObject, NSCoding {

var userid: String
var userName: String
var fullName : String
var email: String
    
    var autoplay: Bool
    var isLogin: Bool
    var dob : String
    var createdAt : String
    var updatedAt : String
    var profile_image : String
    var cover_image : String
    var access_token : String
    var totalListens : String
    var totalMins : String
    var totalUploads : String
    var totalLiked : String
    
    // MARK: init methods
    init(userid: String, username: String, fullName: String, email: String, dob: String, createdAt: String, updatedAt: String, profileImage : String, autoplay: Bool, coverImage: String, access_token: String, isLogin: Bool, totalListens:String, totalMins:String, totalUploads:String, totalLiked:String) {
        self.userid = userid
        self.userName = username
        self.fullName = fullName
        self.email = email
        self.dob = dob
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.profile_image = profileImage
        self.autoplay = autoplay
        self.cover_image = coverImage
        self.access_token = access_token
        self.isLogin = isLogin
        self.totalListens = totalListens
        self.totalMins = totalMins
        self.totalUploads = totalUploads
        self.totalLiked = totalLiked
    }
    
    override init() {
        self.userid = ""
        self.userName = ""
        self.fullName = ""
        self.email = ""
        self.dob = ""
        self.createdAt = ""
        self.updatedAt = ""
        self.profile_image = ""
        self.autoplay = false
        self.cover_image = ""
        self.access_token = ""
        self.isLogin = false
        self.totalListens = ""
        self.totalMins = ""
        self.totalUploads = ""
        self.totalLiked = ""
    }
    
    class func getInstance() -> User? {
        if let data = UserDefaults.standard.object(forKey: k_user) as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? User
        }
        return User(userid: "", username: "", fullName: "", email: "", dob: "", createdAt: "", updatedAt: "", profileImage : "", autoplay: false, coverImage: "", access_token: "", isLogin: false, totalListens: "", totalMins: "", totalUploads: "", totalLiked: "")
    }
    
    func saveUser() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: k_user)
    }
    func setUserData(data : NSDictionary) {
        
        if let user = data.object(forKey: k_user) as? NSDictionary{
            if data.object(forKey: ktoken) != nil {
                let token = data.object(forKey: ktoken)! as! NSDictionary
                self.access_token = token[kaccess_token] as? String ?? ""
            }
            self.userid = "\(user[kId] ?? "")"
            self.userName = user[kuserName] as? String ?? ""
            self.fullName = user[kfullName] as? String ?? ""
            self.email = user[kemail] as? String ?? ""
            self.dob = user[kdob] as? String ?? ""
            self.createdAt = user[kcreatedAt] as? String ?? ""
            self.updatedAt = user[kupdatedAt] as? String ?? ""
            self.profile_image = user[kprofile_image] as? String ?? ""
            self.autoplay = (user[kautoplay] as? Bool) ?? false
            self.cover_image = user[kcover_image] as? String ?? ""
            
            self.isLogin = true
    //        self.totalListens = token[ktotalListens] as? String ?? ""
    //        self.totalMins = token[ktotalMinutes] as? String ?? ""
    //        self.totalUploads = token[ktotalListens] as? String ?? ""
            self.saveUser()
        }
    }
    
    func removeUser() {
        self.userid = ""
        self.userName = ""
        self.fullName = ""
        self.email = ""
        self.dob = ""
        self.createdAt = ""
        self.updatedAt = ""
        self.profile_image = ""
        self.autoplay = false
        self.cover_image = ""
        self.access_token = ""
        self.isLogin = false
        self.totalListens = ""
        self.totalMins = ""
        self.totalUploads = ""
        self.totalLiked = ""
        saveUser()
    }
    
    //MARK: ecoding/decoding methods for custom objects
    required convenience init(coder decoder: NSCoder) {
        let userid = decoder.decodeObject(forKey: kuserid) as? String ?? ""
        let userName = decoder.decodeObject(forKey: kuserName) as? String ?? ""
        let fullName = decoder.decodeObject(forKey: kfullName) as? String ?? ""
        let email = decoder.decodeObject(forKey: kemail) as? String ?? ""
        let dob = decoder.decodeObject(forKey: kdob) as? String ?? ""
        let createdAt = decoder.decodeObject(forKey: kcreatedAt) as? String ?? ""
        let updatedAt = decoder.decodeObject(forKey: kupdatedAt) as? String ?? ""
        let profile_image = decoder.decodeObject(forKey: kprofile_image) as? String ?? ""
        let autoplay: Bool = decoder.decodeBool(forKey: kautoplay) as? Bool ?? false
        let cover_image = decoder.decodeObject(forKey: kcover_image) as? String ?? ""
        let access_token = decoder.decodeObject(forKey: kaccess_token) as? String ?? ""
        let isLogin: Bool = decoder.decodeBool(forKey: kisLogin) as? Bool ?? false
        let totalListens = decoder.decodeObject(forKey: ktotalListens) as? String ?? ""
        let totalMins = decoder.decodeObject(forKey: ktotalMinutes) as? String ?? ""
        let totalUploads = decoder.decodeObject(forKey: kuploadedPods) as? String ?? ""
        let totalLiked = decoder.decodeObject(forKey: ktotalLiked) as? String ?? ""
        
        self.init(userid: userid, username: userName, fullName: fullName, email: email, dob: dob, createdAt: createdAt, updatedAt: updatedAt, profileImage : profile_image, autoplay: autoplay, coverImage: cover_image, access_token: access_token, isLogin: isLogin,totalListens: totalListens,totalMins: totalMins,totalUploads: totalUploads, totalLiked: totalLiked)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.userid, forKey: kuserid)
        coder.encode(self.userName, forKey: kuserName)
        coder.encode(self.fullName, forKey: kfullName)
        coder.encode(self.email, forKey: kemail)
        coder.encode(self.dob, forKey: kdob)
        coder.encode(self.createdAt, forKey: kcreatedAt)
        coder.encode(self.updatedAt, forKey: kupdatedAt)
        coder.encode(self.profile_image, forKey: kprofile_image)
        coder.encode(self.autoplay, forKey: kautoplay)
        coder.encode(self.cover_image, forKey: kcover_image)
        coder.encode(self.access_token, forKey: kaccess_token)
        coder.encode(self.isLogin, forKey: kisLogin)
        coder.encode(self.totalListens, forKey: ktotalListens)
        coder.encode(self.totalMins, forKey: ktotalMinutes)
        coder.encode(self.totalUploads, forKey: kuploadedPods)
        coder.encode(self.totalLiked, forKey: ktotalLiked)
        
    }
}


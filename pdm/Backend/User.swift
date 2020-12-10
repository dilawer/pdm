//
//  UserInfo.swift
//
//  Created by Dilawer Hussain on 12/10/20.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

import UIKit

let kuserid = "userid"
let kuserName = "userName"
let kfullName = "fullName"
let kemail = "email"
let kdob = "dob"
let kcreatedAt = "createdAt"
let kupdatedAt = "updatedAt"
let kprofile_image = "profileImage"
let kautoplay = "autoplay"
let kcover_image = "coverImage"

let k_user = "user"


class User: NSObject, NSCoding {

var userid: String
var userName: String
var fullName : String
var email: String
    
    var autoplay: Bool
    var dob : String
var createdAt : String
var updatedAt : String
var profile_image : String
var cover_image : String
    

    
    
    
    
    // MARK: init methods
    init(userid: String, username: String, fullName: String, email: String, dob: String, createdAt: String, updatedAt: String, profileImage : String, autoplay: Bool, coverImage: String) {
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
        
    }
    
    class func getInstance() -> User? {
        if let data = UserDefaults.standard.object(forKey: k_user) as? NSData {
//            return NSK
            return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? User
        }
        return User(userid: "", username: "", fullName: "", email: "", dob: "", createdAt: "", updatedAt: "", profileImage : "", autoplay: false, coverImage: "")
    }
    
    func saveUser() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: k_user)
    }
    func setUserData(data : NSDictionary) {
        
        self.userid = data[kId] as? String ?? ""
        self.userName = data[kuserName] as? String ?? ""
        self.fullName = data[kfullName] as? String ?? ""
        self.email = data[kemail] as? String ?? ""
        self.dob = data[kdob] as? String ?? ""
        self.createdAt = data[kcreatedAt] as? String ?? ""
        self.updatedAt = data[kupdatedAt] as? String ?? ""
        self.profile_image = data[kprofile_image] as? String ?? ""
        self.autoplay = data[kautoplay] as! Bool
        self.cover_image = data[kcover_image] as? String ?? ""
        self.saveUser()
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
        saveUser()
    }
    
    //MARK: ecoding/decoding methods for custom objects
    required convenience init(coder decoder: NSCoder) {
        let userid = decoder.decodeObject(forKey: kuserid) as! String
        let userName = decoder.decodeObject(forKey: kuserName) as! String
        let fullName = decoder.decodeObject(forKey: kfullName) as! String
        let email = decoder.decodeObject(forKey: kemail) as! String
        let dob = decoder.decodeObject(forKey: kdob) as! String
        let createdAt = decoder.decodeObject(forKey: kcreatedAt) as! String
        let updatedAt = decoder.decodeObject(forKey: kupdatedAt) as! String
        let profile_image = decoder.decodeObject(forKey: kprofile_image) as! String
        let autoplay: Bool = decoder.decodeBool(forKey: kautoplay)
        let cover_image = decoder.decodeObject(forKey: kcover_image) as! String
        
        self.init(userid: userid, username: userName, fullName: fullName, email: email, dob: dob, createdAt: createdAt, updatedAt: updatedAt, profileImage : profile_image, autoplay: autoplay, coverImage: cover_image)
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
        
    }
}


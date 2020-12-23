//
//  Global.swift
//  pdm
//
//  Created by Muhammad Aqeel on 22/12/2020.
//

import Foundation
import UIKit

class Global {
    class var shared : Global {
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    var clientID = "544543275549-hr64aecbu2p7tvdb8ul8bokpg49r41sm.apps.googleusercontent.com"
//    var clientID = "432086961037-6g24qk7rln16meotmi3dt02i6mtc5s2b.apps.googleusercontent.com"
    var imageUrl = "https://pod-digital-media-bucket.s3.us-east-2.amazonaws.com/category_icon/"
}

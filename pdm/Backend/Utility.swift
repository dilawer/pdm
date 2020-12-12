//
//  Utility.swift
//  PDM
//
//  Created by Dilawer Hussain on 10/12/20.
//  Copyright © 2020 Dilawer Hussain. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import AVFoundation
import Alamofire
import CoreLocation


class Utility: NSObject{
    
    
    class func isInternetConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
//
//    class func startSpinner(view: UIView) -> UIActivityIndicatorView {
//        var activityIndicator = UIActivityIndicatorView()
//        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//        activityIndicator.color = UIColor.darkGray
//        activityIndicator.center = view.center
//        activityIndicator.startAnimating()
//        view.addSubview(activityIndicator)
//        return activityIndicator
//    }
//
//    class func stopSpinner(activityIndicator: UIActivityIndicatorView) {
//        activityIndicator.stopAnimating()
//    }
    
    class func showAlertWithOptions(controller: UIViewController, title: String, message: String, preferredStyle: UIAlertController.Style, rightBtnText: String, leftBtnText: String, leftBtnhandler: ((UIAlertAction) -> Swift.Void)? = nil, rightBtnhandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        // add an action (button)
        alert.addAction(UIAlertAction(title: leftBtnText, style: UIAlertAction.Style.default, handler: leftBtnhandler))
        alert.addAction(UIAlertAction(title: rightBtnText, style: UIAlertAction.Style.default, handler: rightBtnhandler))
        // show the alert
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithSingleOption(controller: UIViewController, title: String, message: String, preferredStyle: UIAlertController.Style, buttonText: String, buttonHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        // add an action (button)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: buttonHandler))
        // show the alert
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func stringNullCheck(stringToCheck: AnyObject) -> String {
        if let val = stringToCheck as? String{
            return val
        }else{
            if stringToCheck is NSNull{
                return ""
            }else{
                return "\(stringToCheck)"
            }
        }
    }
    
    //Mark: Attribueted alert text
    class func getAttributedAlertText(regularText: String) -> NSAttributedString {
        let greyText  = " (photos only)."
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.lightGray] as [NSAttributedString.Key : Any]
        let attributedString = NSMutableAttributedString(string:greyText, attributes: attrs)
        let regularString = NSMutableAttributedString(string:regularText)
        regularString.append(attributedString)
        return regularString
    }
    
    //Mark: image resizing method
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    class func height(forWidth width: CGFloat, size: CGSize) -> CGFloat {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        let rect = AVMakeRect(
            aspectRatio: size,
            insideRect: boundingRect
        )
        return rect.size.height
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

struct Constants {
    static let allowedCharacterSet = (CharacterSet(charactersIn: " |").inverted)
}

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        do {
            if let z = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: AnyObject]
            {
                return z
            }
        } catch let parseError {
            print(parseError)
            return parseError
        }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
   var subStringAfterLastslash : String {
        guard let subrange = self.range(of: "/\\s?", options: [.regularExpression, .backwards]) else { return self }
        return String(self[subrange.upperBound...])
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


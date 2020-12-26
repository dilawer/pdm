//
//  Extension.swift
//  pdm
//
//  Created by Muhammad Aqeel on 22/12/2020.
//

import Foundation
import UIKit
import AVKit

extension String{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    func validatePhone() -> Bool {
        let PHONE_REGEX = "^\\d{3,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
extension UIColor {
    @objc class var greenColor:UIColor{
        return hexStringToUIColor(hex: "#8DBF41")
    }
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
extension Double{
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
}
extension AudioErrorType: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .alreadyRecording:
            return "The application is currently recording sounds"
        case .alreadyPlaying:
            return "The application is already playing a sound"
        case .notCurrentlyPlaying:
            return "The application is not currently playing"
        case .audioFileWrongPath:
            return "Invalid path for audio file"
        case .recordFailed:
            return "Unable to record sound at the moment, please try again"
        case .playFailed:
            return "Unable to play sound at the moment, please try again"
        case .recordPermissionNotGranted:
            return "Unable to record sound because the permission has not been granted. This can be changed in your settings."
        case .internalError:
            return "An error occured while trying to process audio command, please try again"
        }
    }
}
extension URL {
    static func checkPath(_ path: String) -> Bool {
        let isFileExist = FileManager.default.fileExists(atPath: path)
        return isFileExist
    }
    
    static func documentsPath(forFileName fileName: String) -> URL? {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let writePath = URL(string: documents)!.appendingPathComponent(fileName)
        
        var directory: ObjCBool = ObjCBool(false)
        if FileManager.default.fileExists(atPath: documents, isDirectory:&directory) {
            return directory.boolValue ? writePath : nil
        }
        return nil
    }
}
extension UIViewController{
    func handleResponse<T:Decodable>(data:Data?) -> T? {
        guard let data = data else {
            return nil
        }
        var response:T? = nil
        do{
            response = try data.decode(T.self)
        } catch{
            
        }
        return response
    }
}
extension Data {
    func decode<T:Decodable>(_ type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        do{
            let res = try decoder.decode(T.self, from: self)
            print(res)
        } catch{
            print(error.localizedDescription)
        }
        guard let loaded = try? decoder.decode(T.self, from: self) else {
            throw DecodeError.ErrorWhileDecoding
        }
        return loaded
    }
}
extension Encodable {
    var string: String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
                switch identifier {
                case "iPod5,1": return "iPod Touch 5"
                case "iPod7,1": return "iPod Touch 6"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
                case "iPhone4,1": return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2": return "iPhone 5"
                case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
                case "iPhone7,2": return "iPhone 6"
                case "iPhone7,1": return "iPhone 6 Plus"
                case "iPhone8,1": return "iPhone 6s"
                case "iPhone8,2": return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3": return "iPhone 7"
                case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
                case "iPhone8,4": return "iPhone SE"
                case "iPhone10,1", "iPhone10,4": return "iPhone 8"
                case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6": return "iPhone X"
                case "iPhone11,2": return "iPhone XS"
                case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
                case "iPhone11,8": return "iPhone XR"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
                case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
                case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
                case "iPad5,3", "iPad5,4": return "iPad Air 2"
                case "iPad6,11", "iPad6,12": return "iPad 5"
                case "iPad7,5", "iPad7,6": return "iPad 6"
                case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
                case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
                case "iPad5,1", "iPad5,2": return "iPad Mini 4"
                case "iPad6,3", "iPad6,4": return "iPad Pro 9.7 Inch"
                case "iPad6,7", "iPad6,8": return "iPad Pro 12.9 Inch"
                case "iPad7,1", "iPad7,2": return "iPad Pro 12.9 Inch 2. Generation"
                case "iPad7,3", "iPad7,4": return "iPad Pro 10.5 Inch"
                case "AppleTV5,3": return "Apple TV"
                case "AppleTV6,2": return "Apple TV 4K"
                case "AudioAccessory1,1": return "HomePod"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default: return identifier
                }
            #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

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
            let res = try? decoder.decode(T.self, from: self)
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

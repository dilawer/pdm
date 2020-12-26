//
//  Enum.swift
//  pdm
//
//  Created by Muhammad Aqeel on 22/12/2020.
//

import Foundation
enum LoginType:String {
    case email = "1"
    case userName = "2"
}
enum DecodeError: Error {
    case ErrorWhileDecoding
}
enum AudioErrorType: Error {
    case alreadyRecording
    case alreadyPlaying
    case notCurrentlyPlaying
    case audioFileWrongPath
    case recordFailed
    case playFailed
    case recordPermissionNotGranted
    case internalError
}
enum PhotoMediaType {
    case camera
    case gallery
}

//
//  ApplicationOpportunities.swift
//  tabBarFotoCamera
//
//  Created by Username on 05.11.2019.
//  Copyright © 2019 Username. All rights reserved.

import UIKit
import AVFoundation
import Photos

enum PhotoStatus {
    case permitted      //доступ разрещен
    case ban            //доступ запрещен
    case pressTrue      //разрешил доступ
    case pressBan       //запретил доступ
    case noValue        //не определился
}

class ApplicationOpportunities: NSObject {

    static func dismisCameraVC(completion: @escaping (PhotoStatus) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            completion(.ban)
        case .restricted:
            completion(.noValue)
        case .authorized:
            //доступ разрещен
            completion(.permitted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    completion(.pressTrue)
                    //нажал разрешить
                } else {
                    completion(.pressBan)
                }
            }
        }
    }

    static func checkPhotoLibraryPermission(completion: @escaping (PhotoStatus) -> Void) {
        print("999955555555555")
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(.permitted)
            //доступ разрещен
        case .denied, .restricted :
            completion(.ban)
        case .notDetermined://не определился
//            KeysUDef.askedQuestionPfotoLibs.saveBool(true)
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("Authorized, proceed")
                    completion(.permitted)

                case .denied, .restricted:
                    print("Authorized, proceed")

                case .notDetermined:
                    print("Authorized")
                }
            }
        }
    }

}

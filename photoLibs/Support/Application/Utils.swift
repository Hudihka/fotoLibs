//
//  Utils.swift
//  tabBarFotoCamera
//
//  Created by Username on 05.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


enum Utils {

    static func openUrl(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    static func openSystemSettings() {
        if let url = URL(string: "App-Prefs:") {
            openUrl(url)
        }
    }

    static func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            openUrl(url)
        }
    }

    static func call(phone: String) {
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}

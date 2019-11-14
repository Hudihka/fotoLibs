//
//  SupportNotification.swift
//  tabBarFotoCamera
//
//  Created by Username on 07.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


class SupportNotification: NSObject {
    static func notific (name: String) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil)
    }

    static func notificInObj (name: String, obj: [String: Any]) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil, userInfo: obj)
    }

    static func notificImage(_ image: UIImage){
        NotificationCenter.default.post(name: NSNotification.Name.reloadSelectedImage, object: nil, userInfo: ["image": image])
    }

    static func notificClearImage(index: IndexPath, isClear: Bool){
        let userInfo: [AnyHashable : Any]? = ["index": index, "isClear": isClear]

        NotificationCenter.default.post(name: NSNotification.Name.clearIndex, object: nil, userInfo: userInfo)
    }
}



extension Notification.Name {

    static let reloadSelectedImage = Notification.Name("reloadSelectedImage")

    static let clearIndex = Notification.Name("clearIndex")

}

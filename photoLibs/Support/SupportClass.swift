//
//  SupportClass.swift
//  tabBarFotoCamera
//
//  Created by Username on 06.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//


import UIKit

class SupportClass: NSObject {

    enum Dimensions {
        static let hDdevice = UIScreen.main.bounds.size.height
        static let wDdevice = UIScreen.main.bounds.size.width
    }

    static var isIPhone5: Bool {
        return UIScreen.main.bounds.size.height == 568
    }

    static var isIPhoneXorXmax: Bool {
        return UIScreen.main.bounds.size.height >= 812
    }

    //downConstrait нужен для айфона 5, тк в некоторых случаях кнопка скакала
    static let downConstrait: CGFloat = UIScreen.main.bounds.size.height - SupportClass.statusBarHeight - 44

    //////////////////новые значени, в дальнейшем ориентируйся на них

    static let indentNavigationBarHeight: CGFloat = SupportClass.statusBarHeight + SupportClass.navigBarHeight //88 : 64
    static let statusBarHeight: CGFloat = SupportClass.isIPhoneXorXmax ? 44 : 20
    static let navigBarHeight: CGFloat = 44

    static let heightTabBar: CGFloat = SupportClass.isIPhoneXorXmax ? 84 : 49

    static let defaultFrameNBar: CGRect = CGRect(x: 0,
                                                 y: SupportClass.statusBarHeight,
                                                 width: UIScreen.main.bounds.size.width,
                                                 height: SupportClass.navigBarHeight)

    static let finalFrameHederTV: CGRect = CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.size.width,
                                                  height: UIScreen.main.bounds.size.width * 87 / 125 )

}

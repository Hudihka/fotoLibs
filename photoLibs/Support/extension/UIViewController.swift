//
//  UIViewController.swift
//  photoLibs
//
//  Created by Username on 10.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{

    var stackVC: [UIViewController]? { //выдает стек вью контроллеров когда нет таб бара
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let viewControllers = appDelegate.window?.rootViewController?.children {
                return viewControllers
            }
        }

        return nil
    }
}

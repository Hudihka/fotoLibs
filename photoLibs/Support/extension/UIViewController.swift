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
    var lastPushVC: UIViewController? { //получаем последний запушенный вью конроллер в стеке

        if let TBVC = self.presentingViewController as? UITabBarController {
            let index = TBVC.selectedIndex
            if let NVC = TBVC.viewControllers?[index] as? UINavigationController {
                if let lastVc = NVC.topViewController {
                    return lastVc
                }
            }
        }

        if let navigStack = self.stackVC?.last {
            return navigStack
        }

        return nil
    }

    private var stackVC: [UIViewController]? { //выдает стек вью контроллеров когда нет таб бара
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let viewControllers = appDelegate.window?.rootViewController?.children {
                return viewControllers
            }
        }

        return nil
    }
}

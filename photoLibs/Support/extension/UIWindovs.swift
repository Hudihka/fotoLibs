//
//  UIWindovs.swift
//  tabBarFotoCamera
//
//  Created by Username on 06.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    func getWorkVC() -> UIViewController {
        return self.keyWindow?.visibleViewController ?? UIViewController()
    }
}

public extension UIWindow {
    public var visibleViewController: UIViewController? {  //UIApplication.shared.keyWindow?.visibleViewController получить активный ВК
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }

    func transitionRoot(to: UIViewController?) {
        //.transitionFlipFromLeft

        //.transitionCurlUp листаем сттраницы
        //.transitionCrossDissolve по сути пресент плавный и без анимации
        //.transitionFlipFromTop    переворот но не с права на лево а с верху в низ
        //.preferredFramesPerSecond60 вообще хрен знает
        if let VC = to {
            UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.rootViewController = VC
            })
        }
    }
}

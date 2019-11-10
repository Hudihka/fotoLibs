//
//  TabBarVC.swift
//  tabBarFotoCamera
//
//  Created by Username on 05.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


class TabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    func setupTabBar() {
        self.selectedIndex = 0

        if let arrauVC = viewControllers {
            for (index, vc) in arrauVC.enumerated(){
                let tabInfo = MainTab.allCases[index]
                vc.tabBarItem.title = tabInfo.title
                vc.tabBarItem.image = tabInfo.icons.normal.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.selectedImage = tabInfo.icons.selected.withRenderingMode(.alwaysOriginal)

            }
        }

    }
}


enum MainTab: String, CaseIterable {
    case twoButtom
    case alert

    var title: String {
        switch self {
        case .twoButtom:
            return "кнопки"

        case .alert:
            return "алерт"
        }
    }

    var icons: (normal: UIImage, selected: UIImage) {
        var cartage: (UIImage?, UIImage?) = (nil, nil)

        switch self {
        case .twoButtom:
            cartage = (UIImage(named: "fridge"), UIImage(named: "fridgePress"))

        case .alert:
            cartage = (UIImage(named: "basket"), UIImage(named: "basketPress"))

        }

        return (cartage.0 ?? UIImage(), cartage.1 ?? UIImage())
    }
}

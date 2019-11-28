//
//  FrieButtonVCTransition.swift
//  photoLibs
//
//  Created by Username on 18.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


extension FrieButtonVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return PresentCameraAnimation(startPoint: pointTransition, isMyCameraVC: myPhotoTransition)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return DismissCameraAnimation(finalPoint: pointTransition)

    }


}

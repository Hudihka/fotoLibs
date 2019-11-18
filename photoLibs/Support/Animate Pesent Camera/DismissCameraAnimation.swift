//
//  DismissCameraAnimation.swift
//  photoLibs
//
//  Created by Username on 18.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


class DismissCameraAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let finalPoint: CGPoint

    init(finalPoint: CGPoint) {
        self.finalPoint = finalPoint
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTimeInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let twoButtonVC = transitionContext.viewController(forKey: .to),     // до, вью контроллер с изображением
//            let cameraVC = CameraViewController.route(),
//            let snapshot = cameraVC.view.snapshotView(afterScreenUpdates: true),
            //////
            let cameraVC = transitionContext.viewController(forKey: .from),
            let snaphotCamera = cameraVC.view.snapshotView(afterScreenUpdates: true)

            else {
                return
        }


//        if let vcImageTest = transitionContext.viewController(forKey: .from) as? UINavigationController {
//            if let stockVCTest = transitionContext.viewController(forKey: .to) as? UINavigationController{
//                ////
//            }
//        }

//        toVCN.setViewControllers([cameraVC], animated: false)
//        cameraVC.customNavigationBar()

        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear

        let maskView = MaskCircleView(frame: snaphotCamera.frame)
        snaphotCamera.addSubview(maskView)

        containerView.addSubview(twoButtonVC.view)     
        containerView.addSubview(snaphotCamera)


        maskView.finishPoint = finalPoint
        maskView.​configure()

//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.3) {
//            snaphotTwoButton.removeFromSuperview()
//        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.8) {
            snaphotCamera.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}

//
//  PresentCameraAnimation.swift
//  photoLibs
//
//  Created by Username on 18.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit

let animationTimeIntervalCamera: TimeInterval = 0.3

class PresentCameraAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let startPoint: CGPoint

    init(startPoint: CGPoint) {
        self.startPoint = startPoint
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTimeInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toVCN = transitionContext.viewController(forKey: .to) as? UINavigationController,     // до, вью контроллер с изображением
              let cameraVC = CameraViewController.route(),
              let snapshot = cameraVC.view.snapshotView(afterScreenUpdates: true),
            //////
              let twoButtonVC = transitionContext.viewController(forKey: .from),
              let snaphotTwoButton = twoButtonVC.view.snapshotView(afterScreenUpdates: true)

            else {
                return
        }

        toVCN.setViewControllers([cameraVC], animated: false)
        cameraVC.customNavigationBar()

        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear

        let maskView = MaskCircleView(frame: snapshot.frame)
        snapshot.addSubview(maskView)

        containerView.addSubview(toVCN.view)     //в начале в контейнер добавляем конечный
        containerView.addSubview(snaphotTwoButton)
        containerView.addSubview(snapshot)


        maskView.startPoint = startPoint
        maskView.​configure()

//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.3) {
//            snaphotTwoButton.removeFromSuperview()
//        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            snaphotTwoButton.removeFromSuperview()
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}

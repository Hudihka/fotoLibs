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

        guard let frieButtonVCVC = transitionContext.viewController(forKey: .to),
            let cameraVC = transitionContext.viewController(forKey: .from),
            let snaphotCamera = cameraVC.view.snapshotView(afterScreenUpdates: true)

            else {
                return
        }


        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear

        let maskView = MaskCircleView(frame: snaphotCamera.frame)
        snaphotCamera.addSubview(maskView)

        containerView.addSubview(frieButtonVCVC.view)     
        containerView.addSubview(snaphotCamera)


        maskView.finishPoint = finalPoint
        maskView.​configure()


        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            snaphotCamera.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}

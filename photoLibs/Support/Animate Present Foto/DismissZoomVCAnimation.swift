//
//  DismissStockAnimation.swift
//  animation translate
//
//  Created by Username on 20.09.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class DismissZoomVCAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let finalFrame: CGRect

    init(finalFrame: CGRect) {
        self.finalFrame = finalFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTimeInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let vcImageZoom = transitionContext.viewController(forKey: .from) as? ImageZoomVC // до, вью контроллер с Изображением
            else {
                return
        }

        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear


        let counterIndex = IndexPath(row: vcImageZoom.counter, section: 0)

        var image = UIImage()
        var startFrame = CGRect()
        if let img = vcImageZoom.imageActive {
            image = img

            let frameIMG = img.positionCentrWindovsScaleAspectFill

            startFrame = CGRect(x: 0,
                                y: ImageZoomVC.positionY + frameIMG.origin.y,
                                width: SupportClass.Dimensions.wDdevice,
                                height: frameIMG.height )
        }

        let snaphot = UIImageView(frame: startFrame)

        snaphot.image = image
        snaphot.backgroundColor = UIColor.clear
        snaphot.contentMode = .scaleAspectFill
        snaphot.clipsToBounds = true

        let addRadius = transitionContext.viewController(forKey: .to) is UINavigationController

        let startAlpha = ImageZoomVC.alphaContent(value: abs(ImageZoomVC.positionY))

        vcImageZoom.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: startAlpha)
        vcImageZoom.collectionView.isHidden = true


        containerView.addSubview(vcImageZoom.view)
        containerView.addSubview(snaphot)


        UIApplication.shared.updateStatusBar(false)
        UIApplication.shared.setStatusBarStyle(.default, animated: true)

        UIView.animate(withDuration: animationTimeInterval + 0.02,
                       animations: {
                        snaphot.frame = self.finalFrame
                        if addRadius {
                            snaphot.addRadius(number: 8)
                        }
                        vcImageZoom.view.backgroundColor = UIColor.clear

        }) { (comp) in
            if comp {
                snaphot.removeFromSuperview()
                vcImageZoom.view.removeFromSuperview()

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

    }
}

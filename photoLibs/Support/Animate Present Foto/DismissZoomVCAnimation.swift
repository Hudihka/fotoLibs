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

        guard let vcImageZoom = transitionContext.viewController(forKey: .from) as? ImageZoomVC, // до, вью контроллер с Изображением
              let photoCollectionVC = transitionContext.viewController(forKey: .to)               //вью контроллер с коллекцией фото
            else {
                return
        }

        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear

        let startFrame = CGRect(x: 0,
                                y: ImageZoomVC.positionY,
                                width: SupportClass.Dimensions.wDdevice,
                                height: SupportClass.Dimensions.hDdevice )

        let snaphot = UIImageView(frame: startFrame)

        let counterIndex = IndexPath(row: vcImageZoom.counter, section: 0)

        if let cell = vcImageZoom.collectionView.cellForItem(at: counterIndex) as? CellZoom, let img = cell.imageScrollView.imageZoomView.image {
            snaphot.image = img
        }


        snaphot.backgroundColor = UIColor.clear
        snaphot.contentMode = .scaleAspectFit
        snaphot.clipsToBounds = true

        let startAlpha = ImageZoomVC.alphaContent(value: abs(ImageZoomVC.positionY))

        vcImageZoom.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: startAlpha)
        vcImageZoom.collectionView.isHidden = true


        containerView.addSubview(vcImageZoom.view)
        containerView.addSubview(snaphot)


        UIView.animate(withDuration: animationTimeInterval + 0.02,
                       animations: {
                        snaphot.frame = self.finalFrame
                        vcImageZoom.view.backgroundColor = UIColor.clear

        }) { (comp) in
            if comp {
                snaphot.removeFromSuperview()
                vcImageZoom.view.removeFromSuperview()

                UIApplication.shared.updateStatusBar(false)
                UIApplication.shared.setStatusBarStyle(.default, animated: true)

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

    }
}

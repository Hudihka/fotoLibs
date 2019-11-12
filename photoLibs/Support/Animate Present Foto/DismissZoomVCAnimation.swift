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


        let startAlpha = ImageZoomVC.alphaContent(value: abs(ImageZoomVC.positionY))
        let snaphot = UIImageView(frame: startFrame)

        snaphot.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: startAlpha)
        snaphot.contentMode = .scaleAspectFit

        let counterIndex = IndexPath(row: vcImageZoom.counter, section: 0)

        if let cell = vcImageZoom.collectionView.cellForItem(at: counterIndex) as? CellZoom, let img = cell.imgBackAnimation {
            snaphot.image = img
        }


        containerView.addSubview(photoCollectionVC.view)
        containerView.addSubview(snaphot)


        UIView.animate(withDuration: animationTimeInterval + 0.02,
                       animations: {
                        snaphot.frame = self.finalFrame

        }) { (comp) in
            if comp {
                snaphot.removeFromSuperview()
//                photoCollectionVC.view.removeFromSuperview()
//                vcImage.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

    }
}

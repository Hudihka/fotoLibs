//
//  DismissStockAnimation.swift
//  animation translate
//
//  Created by Username on 20.09.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit



class DismissStockAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let originFrame: CGRect
    private let index: IndexPath

    init(originFrame: CGRect, index: IndexPath) {
        self.originFrame = originFrame
        self.index = index
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTimeInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

//        guard let vcImage = transitionContext.viewController(forKey: .from) as? TwoViewController, // до, вью контроллер с Изображением
//              let stockVC = transitionContext.viewController(forKey: .to)       //вью контроллер с КОЛЛЕКЦИЕЙ
//
//            else {
//                return
//        }
//
//        let containerView = transitionContext.containerView
//        let startFrame = CGRect(x: 0, y: 0, width: Dimensions.wDdevice, height: Dimensions.wDdevice * 87/125 )
//
//        let snaphot = UIImageView(frame: startFrame)
//        snaphot.clipsToBounds = true
//        snaphot.contentMode = .scaleAspectFill
//        snaphot.layer.masksToBounds = true
//
//        let imageTranslation = vcImage.imageV.image
//
//        snaphot.image = imageTranslation
//        vcImage.imageV.image = nil
//        vcImage.view.alpha = 1
//
//        containerView.addSubview(stockVC.view)     //в начале в контейнер добавляем конечный
//        containerView.addSubview(vcImage.view)
//        containerView.addSubview(snaphot)          //а сверху кладем снимок экрана с табл, тк потом экран с таблицей анимац расстворится
//
//
//        UIView.animateKeyframes(
//            withDuration: animationTimeInterval + 0.02,
//            delay: 0,
//            options: .calculationModeCubic,
//            animations: {
//                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 41/42) {
//                    snaphot.addRadius(number: 8)
//                    vcImage.view.alpha = 0
//                    snaphot.frame = self.originFrame
//                }
//
//                UIView.addKeyframe(withRelativeStartTime: 41/42, relativeDuration: 1/42) {
//                    snaphot.alpha = 0
//                }
//        },
//            completion: { (compl) in
//                if compl == true{
////                    snaphot.alpha = 0
//                    snaphot.removeFromSuperview()
//                    vcImage.view.removeFromSuperview()
//                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//                }
//        })

    }
}

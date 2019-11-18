//
//  TwoButtonTransition.swift
//  photoLibs
//
//  Created by Username on 18.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


extension TwoButtonVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let point = photoButton.center
        return PresentCameraAnimation(startPoint: point)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return nil

//        let tupls = getFrameImageView()
//        DispatchQueue.main.asyncAfter(deadline: .now() + animationTimeInterval - 0.04) {
//            let image = UIImage(named: "imag_\(tupls.1.row)") ?? UIImage()
//            self.clearImageCell(index: tupls.1, image: image)
//        }

//        return DismissStockAnimation(originFrame: tupls.0, index: tupls.1)
        //        guard let revealVC = dismissed as? TwoViewController else {
        //            return nil
        //        }
        //
        //        return nil
        //        return FlipDismissAnimationController(destinationFrame: cardView.frame, interactionController: revealVC.swipeInteractionController)
    }


}

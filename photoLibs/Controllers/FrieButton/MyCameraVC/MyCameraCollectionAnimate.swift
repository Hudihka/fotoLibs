//
//  CameraVCPresentCollectionAnimate.swift
//  photoLibs
//
//  Created by Username on 14.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit

extension MyCameraVC: DelegateSelectedCell, UIViewControllerTransitioningDelegate{


    func pressCell(_ index: IndexPath, rect: CGRect) {

        if let vc = ImageZoomVC.route(index: index.row){
            vc.transitioningDelegate = self
            self.present(vc, animated: true, completion: nil)
        }

    }


    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if let img = viewPhotoCollection.bigUIImage {
            self.viewPhotoCollection.collectionView.clearImageCell(clear: true, index: viewPhotoCollection.selectedIndex)

            return PresentZoomVCAnimation(originFrame: frameImageView, image: img)
        }

        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        DispatchQueue.main.asyncAfter(deadline: .now() + animationTimeInterval - 0.02) {
            self.viewPhotoCollection.collectionView.clearImageCell(clear: false, index: self.viewPhotoCollection.selectedIndex)
        }

        return DismissZoomVCAnimation(finalFrame: frameImageView)
    }

    var frameImageView: CGRect {
        let index = viewPhotoCollection.selectedIndex
        let frameCellIsCollectionView = viewPhotoCollection.collectionView.frameImageView(index)

        return CGRect(x: frameCellIsCollectionView.origin.x,
                      y: viewPhotoCollection.frame.origin.y,
                      width: frameCellIsCollectionView.width,
                      height: frameCellIsCollectionView.width)


    }

}


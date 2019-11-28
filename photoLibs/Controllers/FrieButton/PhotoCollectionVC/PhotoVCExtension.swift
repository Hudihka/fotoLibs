//
//  PhotoVCExtension.swift
//  photoLibs
//
//  Created by Username on 14.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit



extension PhotoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            SupportNotification.notificImage(image)
            picker.dismiss(animated: true) {
                UIApplication.shared.getWorkVC.navigationController?.popViewController(animated: true)
            }
        }
    }

}


extension PhotoViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let img = self.bigUIImage {
            self.collectionView.clearImageCell(clear: true, index: selectedIndex)

            return PresentZoomVCAnimation(originFrame: frameImageView, image: img)
        }

        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        DispatchQueue.main.asyncAfter(deadline: .now() + animationTimeInterval - 0.02) {
            self.collectionView.clearImageCell(clear: false, index: self.selectedIndex)
        }

        return DismissZoomVCAnimation(finalFrame: frameImageView)
    }

    var frameImageView: CGRect {
        return self.collectionView.frameImageView(selectedIndex)
    }

}

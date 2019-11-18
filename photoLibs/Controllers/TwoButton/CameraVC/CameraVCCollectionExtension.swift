//
//  CameraVCCollectionExtension.swift
//  photoLibs
//
//  Created by Username on 14.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit

extension CameraViewController{

    func addCollection(){

        if self.imagePan == nil{
            return
        }

        if !KeysUDef.openPhotoLibs.getBool() {
            removeObject()
            return
        }


        print("9999999999999")
        ApplicationOpportunities.checkPhotoLibraryPermission { (status) in
            if status == .permitted {
                self.viewPhotoCollection.delegate = self
                self.positionView(0)
                self.addGestures()

                self.startAnimateCollection()

            } else {
                self.removeObject()
            }
        }
    }


    private func startAnimateCollection(){
        self.albButton.addRadius(number: 2)
        self.albButton.alpha = 0

        self.imagePan.image = CellHeightEnum.big.image
        self.imagePan.alpha = 0
        self.viewPhotoCollection.alpha = 0

        UIView.animate(withDuration: 0.3) {
            self.imagePan.alpha = 1
            self.viewPhotoCollection.alpha = 1
            self.albButton.alpha = 1
        }

    }

    private func removeObject(){
        self.imagePan.removeFromSuperview()
        self.viewPhotoCollection.removeFromSuperview()
        self.albButton.removeFromSuperview()
    }


    private func addGestures(){
        let swipeOne = UIPanGestureRecognizer(target: self, action: #selector(swipeOneSelector))
        let swipeTwo = UIPanGestureRecognizer(target: self, action: #selector(swipeTwoSelector))
        swipeOne.minimumNumberOfTouches = 1
        swipeTwo.minimumNumberOfTouches = 1

        self.viewPhotoCollection.addGestureRecognizer(swipeOne)
        self.imagePan.addGestureRecognizer(swipeTwo)
    }



    private func positionView(_ value: CGFloat){

        let heightCollection = collectionHeight - value

        let downPositionCollection = SupportClass.Dimensions.hDdevice - 130


        let originYPositionCollection = downPositionCollection - heightCollection

        let frameCollection = CGRect(x: 0,
                                     y: originYPositionCollection,
                                     width: SupportClass.Dimensions.wDdevice,
                                     height: heightCollection)

        //заменить 30 на высоту имаге, 60 на ширину

        let widthImage:CGFloat = 60
        let heightImage:CGFloat = 20


        let xPositionImagePan = (SupportClass.Dimensions.wDdevice - widthImage) / 2
        let yPositionImagePan = originYPositionCollection - heightImage

        let frameImage = CGRect(x: xPositionImagePan,
                                y: yPositionImagePan,
                                width: widthImage,
                                height: heightImage)

        self.viewPhotoCollection.frame = frameCollection
        self.imagePan.frame = frameImage

    }



    private var collectionHeight: CGFloat {
        return openCollectionView ? CellHeightEnum.midl.height : 0
    }

    private func finish(_ value: CGFloat){

        let boolValue = value < 0 ? value : abs(value)
        openCollectionView = boolValue < CellHeightEnum.midl.height/2

    }



    @objc func swipeOneSelector(sender: UIPanGestureRecognizer) {
        gestersFunc(sender: sender)
    }

    @objc func swipeTwoSelector(sender: UIPanGestureRecognizer) {
        gestersFunc(sender: sender)
    }

    private func gestersFunc(sender: UIPanGestureRecognizer){

        if animateUpdate {
            return
        }

        let delta = sender.translation(in: self.view).y
        self.imagePan.image = CellHeightEnum.midl.image
        self.viewPhotoCollection.startUpdateCollection()

        switch sender.state {
        case .began, .changed:
            if delta <= 0, openCollectionView {
                self.positionView(0)
            } else if delta > 0, delta < CellHeightEnum.midl.height, openCollectionView {
                self.positionView(delta)
            } else if delta <= 0, delta >= -1 * CellHeightEnum.midl.height, !openCollectionView{
                self.positionView(delta)
            }


        case .ended:
            print(delta)
            updateAnimateView(delta)


        default:
            break
        }
    }

    func updateAnimateView(_ valuePosition: CGFloat) {
        animateUpdate = true
        self.finish(valuePosition)

        let finishImage = openCollectionView ? CellHeightEnum.big.image : CellHeightEnum.zero.image

        UIView.animate(withDuration: 0.2, animations: {
            self.positionView(0)
        }) { [weak self](comp) in
            if comp {

                self?.imagePan.image = finishImage
                self?.animateUpdate = false
                if self?.openCollectionView ?? true {
                    self?.viewPhotoCollection.finishUpdateCollection()
                }
            }
        }
    }
}

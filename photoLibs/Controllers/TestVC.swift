//
//  TestVC.swift
//  photoLibs
//
//  Created by Username on 13.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    @IBOutlet weak var buttonSnaphot: UIButton!

    @IBOutlet weak var collectionView: ViewPhotoCollection!
    @IBOutlet weak var imagePan: UIImageView!
    @IBOutlet weak var heightConstreint: NSLayoutConstraint!

    lazy var swipeGesture: UIPanGestureRecognizer = {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(swipeSelector))
        swipe.minimumNumberOfTouches = 1
        return swipe
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addCollection()
    }


    @IBAction func snaphotButton(_ sender: UIButton) {


    }

}


extension TestVC{

    func addCollection(){

        if !KeysUDef.openPhotoLibs.getBool() {
            self.imagePan.removeFromSuperview()
            self.collectionView.removeFromSuperview()
            return
        }

        ApplicationOpportunities.checkPhotoLibraryPermission { (status) in
            if status == .permitted{
                self.heightConstreint.constant = CellHeightEnum.midl.height
                self.addGesters()
            } else {
                self.collectionView.removeFromSuperview()
            }
        }
    }

    private func addGesters(){
        self.imagePan.addGestureRecognizer(self.swipeGesture)
//        self.collectionView.addGestureRecognizer(self.swipeGesture)

        self.swipeGesture.cancelsTouchesInView = false
    }

    private func finalValueEnums(_ value: CGFloat) -> CellHeightEnum {

        let finishZeroValue = CellHeightEnum.midl.height / 2
        let delta = (CellHeightEnum.big.height - CellHeightEnum.midl.height) / 2
        let finishMidlValue = CellHeightEnum.midl.height + delta

        if value <= finishZeroValue {
            return CellHeightEnum.zero
        } else if finishZeroValue < value && value <= finishMidlValue {
            return CellHeightEnum.midl
        } else {
            return CellHeightEnum.big
        }
    }

    private func updateView(_ value: CGFloat){

        let enumValue = finalValueEnums(value)
        self.heightConstreint.constant = enumValue.height
        self.imagePan.image = enumValue.image

        UIView.animate(withDuration: 0.15, animations: {
            self.loadViewIfNeeded()
        }) { [weak self](comp) in
            if comp{
                self?.collectionView.valueEnums = enumValue
            }
        }


    }



    func frameCollection(_ heightCollection: CGFloat) -> CGRect {
        return CGRect(x: 0,
                      y: yPosition(heightCollection),
                      width: SupportClass.Dimensions.wDdevice,
                      height: heightCollection)
    }

    private func yPosition(_ heightCollection: CGFloat) -> CGFloat{
        let y = self.buttonSnaphot.frame.origin.y
        return y - heightCollection - 30
    }


    @objc func swipeSelector(sender: UIPanGestureRecognizer) {

        var delta = sender.translation(in: self.view).y
        sender.view?.frame.origin.y = delta


//        delta = CGPoint(x: 100, y: self.frame.size.height / 2)
        print("delta \(delta)")


//        self.view.bringSubviewToFront(imagePan)
//        let translation = sender.translation(in: self.view)
//        imagePan.center = CGPoint(x: imagePan.center.x,
//                                  y: imagePan.center.y + translation.y)
//        sender.setTranslation(CGPoint.zero, in: self.view)

//        let translatedPoint = sender.translation(in: self.view)
//        let x = imagePan.frame.origin.x
//        let newTranslatedPoint = CGPoint(x: x, y: translatedPoint.y)

//        let newHeight = collectionHeight + translatedPoint.y

//        print("translatedPoint.y \(translatedPoint.y)")
//        print("newHeight \(newHeight)")
//
////
//        if newHeight >= 0 && newHeight <= CellHeightEnum.big.height{

//            switch sender.state {
//            case .began, .changed:
//                sender.view?.frame.origin.y = newTranslatedPoint.y
//            case .ended:
//                print("закончили")
//            default:
//                break
//            }




            //            self.viewCollection?.frame = frameCollection(newHeight)
        }

}


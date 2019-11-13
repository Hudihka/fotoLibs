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
    var viewCollection: ViewPhotoCollection? = nil

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

        if KeysUDef.openPhotoLibs.getBool() {
            ApplicationOpportunities.checkPhotoLibraryPermission { (status) in
                if status == .permitted{

                    let frame = self.frameCollection(CellHeightEnum.midl.height)
                    let collection = ViewPhotoCollection(frame: frame)
                    self.viewCollection = collection
                    self.view.addSubview(collection)
                    self.addGesters()
                }
            }
        }
    }

    func addGesters(){
        self.viewCollection?.addGestureRecognizer(self.swipeGesture)
//        self.swipeGesture.delegate = self

        self.swipeGesture.cancelsTouchesInView = false
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


        guard let collectionHeight = self.viewCollection?.frame.height else {
            return
        }

        let translatedPoint = sender.translation(in: self.view)

        let newHeight = collectionHeight + translatedPoint.y

        print("translatedPoint.y \(translatedPoint.y)")
        print("newHeight \(newHeight)")


        if newHeight > CellHeightEnum.zero.height && newHeight < CellHeightEnum.big.height{
            switch sender.state {
            case .began, .changed:
                self.viewCollection?.frame = frameCollection(newHeight)
            case .ended:
                print("закончили")
            default:
                break
            }




            //            self.viewCollection?.frame = frameCollection(newHeight)
        }


    }




}


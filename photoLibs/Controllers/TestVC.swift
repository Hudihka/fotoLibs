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

    var openCollectionView = true
    var animateUpdate = false


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       addCollection()

    }


    @IBAction func snaphotButton(_ sender: UIButton) {


    }

}


extension TestVC{

    func addCollection(){

        if !KeysUDef.openPhotoLibs.getBool() {
            removeObject()
            return
        }

        ApplicationOpportunities.checkPhotoLibraryPermission { (status) in
            if status == .permitted{
                self.positionView(0)
                self.addGestures()
            } else {
                self.removeObject()
            }
        }
    }

    private func removeObject(){
        self.imagePan.removeFromSuperview()
        self.collectionView.removeFromSuperview()
    }


    private func addGestures(){
        let swipeOne = UIPanGestureRecognizer(target: self, action: #selector(swipeOneSelector))
        let swipeTwo = UIPanGestureRecognizer(target: self, action: #selector(swipeTwoSelector))
        swipeOne.minimumNumberOfTouches = 1
        swipeTwo.minimumNumberOfTouches = 1

        self.collectionView.addGestureRecognizer(swipeOne)
        self.imagePan.addGestureRecognizer(swipeTwo)
    }



    private func positionView(_ value: CGFloat){


        let heightCollection = collectionHeight - value

        /*какого то хрена позиция кнопки менялась на 20 пунктов, поэтому был добавлен
         такой код что бы вычислить нижнее положение коллекции
         вообще его можно заменить на let downPositionCollection = buttonView.frame.origin.y - 30 */

//        let upButtonConstr:CGFloat = 25 //25 расстояние от кнопки до коллекции
//        let downButtonConstr:CGFloat = 20 //20 расстояние c низу от кнопки
//        let heightButton:CGFloat = buttonSnaphot.frame.height
//
//        let buttonAllHeight = upButtonConstr + downButtonConstr + heightButton
//
//        let downPositionCollection = SupportClass.Dimensions.hDdevice - buttonAllHeight - SupportClass.heightTabBar

        //////////

        let downPositionCollection = SupportClass.Dimensions.hDdevice - 200


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

        self.collectionView.frame = frameCollection
        self.imagePan.frame = frameImage

    }



    private var collectionHeight: CGFloat {
        return openCollectionView ? CellHeightEnum.midl.height : 0
    }

    private func finish(_ value: CGFloat){

        let boolValue = value < 0 ? value : abs(value)
        openCollectionView = boolValue < CellHeightEnum.midl.height/2

//
//        if value < 0 {
//            openCollectionView = value < CellHeightEnum.midl.height/2
//        } else {
//            openCollectionView = abs(value) < CellHeightEnum.midl.height/2
//        }


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

        UIView.animate(withDuration: 0.2, animations: {
            self.positionView(0)
        }) { [weak self](comp) in
            if comp {
                self?.animateUpdate = false
            }
        }
    }

}


//
//  CameraViewController.swift
//  photoLibs
//
//  Created by Username on 10.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit
import SwiftyCam
import AVFoundation

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {

    @IBOutlet weak var cameraButton: SwiftyCamButton!

    @IBOutlet weak var collectionView: ViewPhotoCollection!
    @IBOutlet weak var imagePan: UIImageView!

    var openCollectionView = true
    var animateUpdate = false

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.layer.cornerRadius = 30
        cameraButton.layer.masksToBounds = true

        cameraButton.layer.borderColor = UIColor.red.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.delegate = self

        cameraDelegate = self
        doubleTapCameraSwitch =  false


        self.customNavigationBar()
        
        self.addCollection()
    }

    static func route() -> CameraViewController?{
        let storubord = UIStoryboard(name: "TwoButton", bundle: nil)
        let VC = storubord.instantiateViewController(withIdentifier: "CameraViewController")
        return VC as? CameraViewController
    }


    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        takePhoto()
    }


    @IBAction func reloadCamera(_ sender: Any) {
        switchCamera()
        rightBBItem(isON: false)
    }



    //MARK: - DESING

    private func customNavigationBar() {
        self.clearNavigationBar()
        self.bbCancel()

        settingsRightBBitem(text: "Фонарик Вкл", alpha: 1)
    }

    private func settingsRightBBitem(text: String, alpha: CGFloat){

        let buttonRight = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(flashDevise))

        buttonRight.isEnabled = alpha == 1

        buttonRight.setTitleTextAttributes([.foregroundColor: UIColor.orange.withAlphaComponent(alpha)], for: .normal)
        buttonRight.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .highlighted)
        navigationItem.rightBarButtonItem = buttonRight

    }

    private func rightBBItem(isON: Bool) { //если тру то включаем

        let text = isON ? "вспышка Выкл" : "вспышка Вкл"
        flashMode = isON ? .on : .off
        let alpha: CGFloat = !isON && currentCamera == .front ? 0.5 : 1

        settingsRightBBitem(text: text, alpha: alpha)
    }


    //flash

    @objc func flashDevise(){

        if currentCamera == .front{
            return
        }

        let device = AVCaptureDevice.default(for: AVMediaType.video)

        if (device != nil) {
            if (device!.hasTorch) {
                do {
                    try device!.lockForConfiguration()
                    if (device!.torchMode == AVCaptureDevice.TorchMode.on) {
                        device!.torchMode = AVCaptureDevice.TorchMode.off
                        rightBBItem(isON: false)
                    } else {
                        rightBBItem(isON: true)
                        do {
                            try device!.setTorchModeOn(level: 1.0)
                        } catch {
                            print(error)
                        }
                    }

                    device!.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }

    }


    private func offFlash(){
        if let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.torchMode == AVCaptureDevice.TorchMode.on {
            device.torchMode = AVCaptureDevice.TorchMode.off
        }
    }


    func  swiftyCam ( _  swiftyCam : SwiftyCamViewController, didTake  photo : UIImage) {
        presentPhoto(image: photo)
    }

    private func presentPhoto(image: UIImage){

        if let vc = ImageZoomVC.route(index: 0, image: image){
            self.present(vc, animated: true, completion: nil)
        }
    }

    deinit {
        ManagerPhotos.shared.imageCache.removeAllObjects()
    }

}


//MARK: - CollectionView

extension CameraViewController{


    func addCollection(){

        if !KeysUDef.openPhotoLibs.getBool() {
            removeObject()
            return
        }

        ApplicationOpportunities.checkPhotoLibraryPermission { (status) in
            if status == .permitted{
                self.positionView(0)
                self.addGestures()
                self.imagePan.image = CellHeightEnum.big.image
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

        self.collectionView.frame = frameCollection
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
        self.collectionView.startUpdateCollection()

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
                    self?.collectionView.finishUpdateCollection()
                }
            }
        }
    }




}


extension UIViewController{
    func clearNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }


    func bbCancel(){
        let button = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(exit))
        button.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .normal)
        button.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .highlighted)
        navigationItem.leftBarButtonItem = button
    }

    @objc func exit(){
        self.dismiss(animated: true, completion: nil)
    }
}

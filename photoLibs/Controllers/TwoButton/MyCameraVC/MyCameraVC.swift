//
//  MyCameraVC.swift
//  photoLibs
//
//  Created by Username on 18.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class MyCameraVC: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!

    @IBOutlet weak var viewPhotoCollection: ViewPhotoCollection!
    @IBOutlet weak var imagePan: UIImageView!
    @IBOutlet weak var albButton: AlbumView!

    var openCollectionView = false
    var animateUpdate = false


    override func viewDidLoad() {
        super.viewDidLoad()

        self.customNavigationBar()

    }

    override func viewDidDisappear(_ animated: Bool) {
        //        super.viewDidDisappear(animated)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addCollection()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imagePan != nil {
            updateAnimateView(0)
        }
    }


    static func route() -> MyCameraVC?{
        let storubord = UIStoryboard(name: "TwoButton", bundle: nil)
        let VC = storubord.instantiateViewController(withIdentifier: "MyCameraVC")
        return VC as? MyCameraVC
    }


    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
//        takePhoto()
    }


    @IBAction func reloadCamera(_ sender: Any) {
//        switchCamera()
//        rightBBItem(isON: false)
    }



    //MARK: - DESING

    func customNavigationBar() {
        self.clearNavigationBar()
        self.bbCancel()

        settingsRightBBitem(text: "Вспышка Вкл", alpha: 1)
    }

    private func settingsRightBBitem(text: String, alpha: CGFloat){

        let buttonRight = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(flashDevise))

        buttonRight.isEnabled = alpha == 1

        buttonRight.setTitleTextAttributes([.foregroundColor: UIColor.orange.withAlphaComponent(alpha)], for: .normal)
        buttonRight.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .highlighted)
        navigationItem.rightBarButtonItem = buttonRight

    }

    private func rightBBItem(isON: Bool) { //если тру то включаем


        //TODO настроить потом
//        flashMode = isON ? .on : .off //это именно включение/отключение вспышки, то что ниже это фонарик
//
//
//        let text = isON ? "вспышка Выкл" : "вспышка Вкл"
//        let alpha: CGFloat = !isON && currentCamera == .front ? 0.5 : 1


        let text = "вспышка Выкл"
        let alpha: CGFloat = 0.5


        settingsRightBBitem(text: text, alpha: alpha)
    }


    //flash

    @objc func flashDevise(){

        //TODO настроить потом
//        if currentCamera == .front{
//            return
//        }

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

//Сделать Фото
//TODO настроить потом

//    func  swiftyCam ( _  swiftyCam : SwiftyCamViewController, didTake  photo : UIImage) {
//        presentPhoto(image: photo)
//    }
//
//    private func presentPhoto(image: UIImage){
//
//        if let vc = ImageZoomVC.route(index: 0, image: image){
//            self.present(vc, animated: true, completion: nil)
//        }
//    }

    deinit {
        super.viewDidDisappear(true)
        ManagerPhotos.shared.imageCache.removeAllObjects()
    }
    


}

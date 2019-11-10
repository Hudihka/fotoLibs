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
        flashEnabled = true

        flashMode = .on

        self.customNavigationBar()
    }

    static func route() -> CameraViewController?{
        let storubord = UIStoryboard(name: "Main", bundle: nil)
        let VC = storubord.instantiateViewController(withIdentifier: "CameraViewController")
        return VC as? CameraViewController
    }


    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        takePhoto()
    }


    @IBAction func reloadCamera(_ sender: Any) {
        //        offFlash()
        switchCamera()
        rightBBItem(isON: false)
    }



    //MARK: - DESING

    private func customNavigationBar() {
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

        let text = isON ? "Вспышка Выкл" : "Вспышка Вкл"
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
//        let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
//        let transitionInfo = GSTransitionInfo(fromView: view)
//        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
//
//        imageViewer.addBBItem()
//
//        self.present(imageViewer, animated: true, completion: nil)
    }

    deinit {
        ManagerPhotos.shared.imageCache.removeAllObjects()
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

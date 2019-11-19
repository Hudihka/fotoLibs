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


enum EnumSettingsBBItem{

    case onButton
    case offButton
    case noEnable

    func valueButton() -> (text: String, alpha: CGFloat){

        switch self {
        case .onButton:
            return (text: "Включить вспышку", alpha: 1)
        case .offButton:
            return (text: "Отключить вспышку", alpha: 1)
        case .noEnable:
            return (text: "Включить вспышку", alpha: 0.5)
        }
    }


}

class MyCameraVC: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!

    @IBOutlet weak var viewPhotoCollection: ViewPhotoCollection!
    @IBOutlet weak var imagePan: UIImageView!
    @IBOutlet weak var albButton: AlbumView!

    var openCollectionView = false
    var animateUpdate = false

    //вспышка

    var settings = AVCapturePhotoSettings()

    //камера

    var captureSession = AVCaptureSession() //сессия захвата медиа

    //ну собственно все камеры
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamrera: AVCaptureDevice?

    var photoOutput: AVCapturePhotoOutput? ///класс захвата изображения

    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?  //слой видео в момент его захвата

    //зумм

    var lastZoomFactor: CGFloat = 1

    @IBOutlet weak var labelZoom: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession.sessionPreset = AVCaptureSession.Preset.photo

        setupDevice()           //настройки девайса
        currentCamrera = backCamera
        setupInputOutput()      //настроить вход-выход
        setupPreviewLayer()     //настройка слоя фотокамеры
        startRunningCaptureSession()

        //настраивает кнопку
        cameraButton.circle()
        cameraButton.layer.borderWidth = 5
        cameraButton.layer.borderColor = UIColor.red.cgColor


        self.customNavigationBar()

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

    //MARK: - ACTION

    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {

        photoOutput?.capturePhoto(with: self.settings, delegate: self)
    }
//
//
    @IBAction func reloadCamera(_ sender: Any) {

        do{
            captureSession.removeInput(captureSession.inputs.first!)
            let value = currentCamrera == frontCamera

            currentCamrera = value ? backCamera : frontCamera

            settingsRightBBitem(currentCamrera == frontCamera ? .noEnable : .onButton)

            lastZoomFactor = 1

            let captureDeviceInput1 = try AVCaptureDeviceInput(device: currentCamrera!)
            captureSession.addInput(captureDeviceInput1)
        }catch{
            print(error.localizedDescription)
        }

    }



    //MARK: - DESING

    func customNavigationBar() {
        self.clearNavigationBar()
        self.bbCancel()

        settingsRightBBitem(EnumSettingsBBItem.onButton)

    }


    private func settingsRightBBitem(_ value: EnumSettingsBBItem){

        let buttonRight = UIBarButtonItem(title: value.valueButton().text, style: .plain, target: self, action: #selector(flashDevise))

        let alpha = value.valueButton().alpha

        buttonRight.isEnabled = alpha == 1

        buttonRight.setTitleTextAttributes([.foregroundColor: UIColor.orange.withAlphaComponent(alpha)], for: .normal)
        buttonRight.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .highlighted)
        navigationItem.rightBarButtonItem = buttonRight

    }

        //если надо только вспышку


    @objc func flashDevise(){

        if let camera = currentCamrera {

            let value = camera.flashMode == AVCaptureDevice.FlashMode.on

            let flashMode: AVCaptureDevice.FlashMode = value ? .off : .on

            settingsRightBBitem(value ? .onButton : .offButton)

            self.settings.flashMode = flashMode
        }

    }


    //если нада фонарик

//        @objc func flashDevise(){
//
//            if let avDevice = AVCaptureDevice.default(for: AVMediaType.video) {
//                if (avDevice.hasTorch) {
//                    do {
//                        try avDevice.lockForConfiguration()
//                    } catch {
//                        print("aaaa")
//                    }
//
//
//                    let isActiveCamera = avDevice.isTorchActive
//
//                    settingsRightBBitem(isActiveCamera ? .onButton : .offButton)
//
//                    avDevice.torchMode = isActiveCamera ? AVCaptureDevice.TorchMode.off : AVCaptureDevice.TorchMode.on
//
//
//                }
//                // unlock your device
//                avDevice.unlockForConfiguration()
//            }
//
//        }


    deinit {
        captureSession.stopRunning()
        ManagerPhotos.shared.imageCache.removeAllObjects()
    }

}

extension MyCameraVC: AVCapturePhotoCaptureDelegate {

    func setupDevice() {
        //Запрос для поиска и мониторинга доступных устройств захвата.
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        //Массив доступных в настоящее время устройств, соответствующих критериям сеанса.
        let devices = deviceDiscoverySession.devices

        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
    }

    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamrera!) //захват того что есть сейчас
            captureSession.addInput(captureDeviceInput)//Добавляет заданный вход в сеанс.
            photoOutput = AVCapturePhotoOutput()       //Выходные данные захвата для неподвижного изображения, Live Photo и других рабочих процессов фотографии.
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])], completionHandler: nil) //полученное фото
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }

    private func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //Указывает, как слой отображает видеоконтент в своих границах.
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)

        //жест
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch))
        self.view.addGestureRecognizer(pinchRecognizer)
    }

    func startRunningCaptureSession() {
        captureSession.startRunning() //запускаем сессию
    }

    //MARK: - сделали фото

    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?){


        if let photoBuffer = photoSampleBuffer {
            let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoBuffer, previewPhotoSampleBuffer: nil)
            openVCZoom(data: data)
        }

        let previewWidth = Int(resolvedSettings.previewDimensions.width)
        let previewHeight = Int(resolvedSettings.previewDimensions.height)

        if let previewBuffer = previewPhotoSampleBuffer {
            if let imageBuffer = CMSampleBufferGetImageBuffer(previewBuffer) {
                let ciImagePreview = CIImage(cvImageBuffer: imageBuffer)
                let context = CIContext()
                if let cgImagePreview = context.createCGImage(ciImagePreview, from: CGRect(x: 0, y: 0, width:previewWidth , height:previewHeight )) {
                    if let vc = ImageZoomVC.route(index: 0, image: UIImage(cgImage: cgImagePreview)){
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }

    }

    private func openVCZoom(data: Data?){
        if let data = data, let imgage = UIImage(data: data), let vc = ImageZoomVC.route(index: 0, image: imgage){
            self.present(vc, animated: true, completion: nil)
        }
    }

    //MARK - жест


    @objc func pinch(sender: UIPinchGestureRecognizer) {

        let newScaleFactor = minMaxZoom(sender.scale * lastZoomFactor)

        switch sender.state {
        case .began: fallthrough
        case .changed:
            update(scale: newScaleFactor)
            updateLabel(isClear: false, scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
            updateLabel(isClear: true, scale: lastZoomFactor)
        default: break
        }
    }

    func update(scale factor: CGFloat) {

        //        let device = currentCamrera.device

        if let camera = currentCamrera {

            do {
                try camera.lockForConfiguration()
                defer { camera.unlockForConfiguration() }
                camera.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }

    private func minMaxZoom(_ factor: CGFloat) -> CGFloat {

        let minimumZoom: CGFloat = 1
        let maximumZoom: CGFloat = 3

        if let currentCamrera = currentCamrera {

            let value1 = max(factor, minimumZoom) //больше текущее значение миним
            let value2 = min(value1, maximumZoom) //меньше максимального

            return min(value2, currentCamrera.activeFormat.videoMaxZoomFactor)
        }

        return 1
    }


    func updateLabel(isClear: Bool, scale: CGFloat){

        let color = isClear ? UIColor.clear : UIColor.white

        self.labelZoom.text = String(format: "%.2f", scale)
        self.labelZoom.textColor = color

    }

}






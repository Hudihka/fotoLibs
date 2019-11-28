//
//  FrieButtonVCVCViewController.swift
//  tabBarFotoCamera
//
//  Created by Username on 05.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class FrieButtonVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoAndVideoButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!

    var myPhotoTransition = true

    var pointTransition: CGPoint {
        return myPhotoTransition ? photoButton.center : photoAndVideoButton.center
    }

    static var openNevStackNavigation = true //если да, то открываем новый стек навигации, переменная нужна для дисмиса

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadSelectedImage),
                                               name: .reloadSelectedImage,
                                               object: nil)
    }

    static func route() -> FrieButtonVC?{
        let storubord = UIStoryboard(name: "FrieButton", bundle: nil)
        let VC = storubord.instantiateViewController(withIdentifier: "FrieButtonVC")
        return VC as? FrieButtonVC
    }


    @objc func reloadSelectedImage(_ notification: Notification) {
        if let img = notification.userInfo?["image"] as? UIImage{
            imageView.image = img
        }
    }


    //MARK: - ACTION

    @IBAction func photoButton(_ sender: UIButton) {

        myPhotoTransition = true
        openCamera()

    }

    @IBAction func photoAndVideoButton(_ sender: UIButton) {

        myPhotoTransition = false
        openCamera()

    }


    private func openCamera(){

        ApplicationOpportunities.dismisCameraVC(completion: { (status) in
            switch status {
            case .ban:
                self.alertNoAccess(camera: true)

            case .permitted, .pressTrue:
                print("открыть фото камеру")

                let NVC = UINavigationController()
                NVC.view.backgroundColor = UIColor.clear
                NVC.transitioningDelegate = self

                self.navigationController?.present(NVC, animated: true, completion: nil)

            case .pressBan, .noValue:
                return
            }
        })
    }


    private func present(controller: UIViewController){

        let navigVC = UINavigationController(rootViewController: controller)
        navigVC.hidesBottomBarWhenPushed = true
        navigVC.modalPresentationStyle = .overFullScreen

        self.present(navigVC, animated: true, completion: nil)
    }

    @IBAction func galeruButton(_ sender: Any) {

        ApplicationOpportunities.checkPhotoLibraryPermission(completion: { (value) in
            switch value {//permitted
            case .pressBan:
                break

            case .ban:
                self.alertNoAccess(camera: false)

            case .permitted, .pressTrue, .noValue:
                if !KeysUDef.openPhotoLibs.getBool() {
                    KeysUDef.openPhotoLibs.saveBool(true)
                    self.openPhotoCamera(false)
                } else {
                    self.openPhotoCamera(true)
                }
            }
        })

    }

    private func openPhotoCamera(_ openImmediately: Bool){

        let time: Double = openImmediately ? 0 : 0.05

        DispatchQueue.main.asyncAfter(deadline: .now() + time) { //может быть противный баг если открыть в первый раз сразу
                                                                 //поэтому делаем небольшую задержку
            if let vc = PhotoViewController.route() {
                FrieButtonVC.openNevStackNavigation = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }


    //MARK - ALERT

    private func alertNoAccess(camera: Bool) {
        let textTitle = camera ? "Доступ к камере запрещен" : "Доступ к фотографиям запрещен"
        let description = "Разрешите приложению BLABLA доступ в настройках"

        let alert = UIAlertController(title: textTitle, message: description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Перейти в настройки", style: UIAlertAction.Style.default, handler: { (_) in
            Utils.openAppSettings() //открыть настройки
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


enum KeysUDef: String {


    case openPhotoLibs          = "разрешить_даступ_к_фотокамере"

    func getBool() -> Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }

    func saveBool( _ value: Bool) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }

}

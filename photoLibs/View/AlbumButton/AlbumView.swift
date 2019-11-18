//
//  AlbumView.swift
//  photoLibs
//
//  Created by Username on 14.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var imageFront: UIImageView!


    override init (frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        settingsView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        settingsView()
    }

    private func settingsView() {
        self.contentView.backgroundColor = UIColor.clear

        if !KeysUDef.openPhotoLibs.getBool() {
            return
        }

        ManagerPhotos.shared.getImageOne(indexPath: IndexPath(row: 0, section: 0)) { (img) in
            self.imageFront.image = img
        }

    }

    private func xibSetup() {
        contentView = loadViewFromNib("AlbumView")
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }

    @IBAction func action(_ sender: Any) {
        if let VC = UIApplication.shared.getWorkVC as? CameraViewController {
            VC.openAlbum()
        }
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    func openAlbum(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary

        self.present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            SupportNotification.notificImage(image)

            picker.dismiss(animated: true) {//камера вк
                UIApplication.shared.lastPushVC?.navigationController?.dismiss(animated: true, completion: nil)
            }

        }
    }


}



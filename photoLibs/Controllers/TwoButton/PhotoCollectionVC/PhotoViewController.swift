//
//  PhotoViewController.swift
//  tabBarFotoCamera
//
//  Created by Username on 06.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let manager = ManagerPhotos.shared
    var counterSpecifiedCell = 0
    var bigUIImage: UIImage? = nil

    var selectedIndex = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()


        settingsCV()
        albomButton()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearIndex),
                                               name: .clearIndex,
                                               object: nil)


    }


    static func route() -> PhotoViewController? {
        let storyboard = UIStoryboard(name: "TwoButton", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PhotoViewController")

        return viewController as? PhotoViewController
    }

   private func albomButton(){
        let button = UIBarButtonItem(title: "Альбомы", style: .plain, target: self, action: #selector(albomButtonSelector))
        button.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .normal)
        button.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .highlighted)
        navigationItem.rightBarButtonItem = button
    }

    @objc func albomButtonSelector(){

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary

        self.present(picker, animated: true, completion: nil)

    }

    @objc func clearIndex(_ notification: Notification) {


        guard let index = notification.userInfo?["index"] as? IndexPath,
            let clear = notification.userInfo?["isClear"] as? Bool else {
                return
        }

        self.selectedIndex = index
        self.collectionView.clearImageCell(clear: clear, index: selectedIndex)

    }

    deinit {
        ManagerPhotos.shared.imageCache.removeAllObjects()
        NotificationCenter.default.removeObserver(self)
    }

}





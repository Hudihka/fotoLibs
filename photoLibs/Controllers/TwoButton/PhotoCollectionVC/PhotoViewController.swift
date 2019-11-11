//
//  PhotoViewController.swift
//  tabBarFotoCamera
//
//  Created by Username on 06.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit
//import GSImageViewerController
//import SPPhotoViewer

class PhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let manager = ManagerPhotos.shared
    var counterSpecifiedCell = 0

    override func viewDidLoad() {
        super.viewDidLoad()


        settingsCV()
//        bbCancel()

    }


    static func route() -> PhotoViewController? {
        let storyboard = UIStoryboard(name: "TwoButton", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PhotoViewController")

        return viewController as? PhotoViewController
    }



    deinit {
        ManagerPhotos.shared.imageCache.removeAllObjects()
        NotificationCenter.default.removeObserver(self)
    }

}

extension PhotoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - CollectionView

    func settingsCV() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(UINib(nibName: "PhotoCollectionCell", bundle: nil),
                                     forCellWithReuseIdentifier: "PhotoCollectionCell")

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell

        if indexPath.row > counterSpecifiedCell {
            counterSpecifiedCell = indexPath.row
            cell.alpha = 0

            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1
            }
        }

        cell.ind = indexPath

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        //        ManagerPhotos.shared.getImageOne(indexPath: indexPath, sizeBig: true) { (img) in
        //            //изображение использовать для анимационного перехода
        //        }

        if let vc = ImageZoomVC.route(index: indexPath.row){
            self.present(vc, animated: true, completion: nil)
        }


        //        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionCell {
        //        }

        //        if let vc = ImageVC.route(array: manager.fetchResult, index: indexPath.row){
        //            self.present(vc, animated: true, completion: nil)
        //        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: manager.height, height: manager.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

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

    deinit {
        ManagerPhotos.shared.imageCache.removeAllObjects()
        NotificationCenter.default.removeObserver(self)
    }

}


extension PhotoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("----------------")


        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            SupportNotification.notificImage(image)
            picker.dismiss(animated: true) {
                ///
            }
        }
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

                ManagerPhotos.shared.getImageOne(indexPath: indexPath, sizeBig: true) { (img) in
                    self.bigUIImage = img
                    self.selectedIndex = indexPath

                    if let vc = ImageZoomVC.route(index: indexPath.row){
                        vc.transitioningDelegate = self
                        vc.delegate = self
                        self.present(vc, animated: true, completion: nil)
                    }
                }
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

extension PhotoViewController: DelegateReloadSelectedCell {
    func reloadCell(index: IndexPath, isSclear: Bool) {

        self.selectedIndex = index
        self.clearImageCell(clear: isSclear)

    }

}


extension PhotoViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let img = self.bigUIImage {
            self.clearImageCell(clear: true)
            return PresentZoomVCAnimation(originFrame: frameImageView, image: img)
        }

        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        DispatchQueue.main.asyncAfter(deadline: .now() + animationTimeInterval - 0.02) {
            self.clearImageCell(clear: false)
        }

        return DismissZoomVCAnimation(finalFrame: frameImageView)
    }

    private func clearImageCell(clear: Bool){

        if let cell = self.collectionView.cellForItem(at: selectedIndex) as? PhotoCollectionCell {
            if clear {
                cell.imageCell.image = nil
            } else {
                cell.ind = selectedIndex
            }
        }
    }

    private var frameImageView: CGRect {


        if let attributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItem(at: selectedIndex) {
            let rect = attributes.frame
            let cellFrameInSuperview = collectionView.convert(rect, to: collectionView.superview)

            return cellFrameInSuperview

        }

        return CGRect()

    }

}

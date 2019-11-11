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


                ManagerPhotos.shared.getImageOne(indexPath: indexPath, sizeBig: true) { (img) in
                    self.bigUIImage = img

                    if let vc = ImageZoomVC.route(index: indexPath.row){
                        vc.transitioningDelegate = self
                        self.present(vc, animated: true, completion: nil)
                    }
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


extension PhotoViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let img = self.bigUIImage {
            let tupls = getFrameImageView()
            self.clearImageCell(ind: tupls.1, clear: true)
            return PresentStockAnimation(originFrame: tupls.0, image: img)
        }
        
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let tupls = getFrameImageView()
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTimeInterval - 0.04) {
            let image = UIImage(named: "imag_\(tupls.1.row)") ?? UIImage()
            self.clearImageCell(index: tupls.1, image: image)
        }

        return DismissStockAnimation(originFrame: tupls.0, index: tupls.1)
    }

    private func clearImageCell(ind: IndexPath, clear: Bool){


        if let cell = self.collectionView.cellForItem(at: ind) as? PhotoCollectionCell {
            if clear {
                cell.imageCell.image = nil
            } else {
                cell.ind = ind
            }
        }
    }

    private func getFrameImageView() -> (CGRect, IndexPath) {

        if let index = collectionView.indexPathsForSelectedItems?.first, let attributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItem(at: index) {
            let rect = attributes.frame
            let cellFrameInSuperview = collectionView.convert(rect, to: collectionView.superview)

            return (cellFrameInSuperview, index)

        }

        return (CGRect(), IndexPath())

    }


}

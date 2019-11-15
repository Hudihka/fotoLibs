//
//  IZoomCollection.swift
//  photoLibs
//
//  Created by Username on 15.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit

extension ImageZoomVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - CollectionView

    func settingsCV() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        self.collectionView.register(UINib(nibName: "CellZoom", bundle: nil),
                                     forCellWithReuseIdentifier: "CellZoom")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCellOne == nil ? countCell : 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellZoom = collectionView.dequeueReusableCell(withReuseIdentifier: "CellZoom", for: indexPath) as! CellZoom

        if imageCellOne == nil {
            cell.ind = indexPath
        } else {
            cell.imageCellOne = imageCellOne
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width,
                      height: UIScreen.main.bounds.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    var imageActive: UIImage? {

        let index = IndexPath(row: counter, section: 0)
        if let cell = collectionView.cellForItem(at: index) as? CellZoom, let img = cell.imageScrollView.imageZoomView.image{
            return img
        }

        return nil
    }
}

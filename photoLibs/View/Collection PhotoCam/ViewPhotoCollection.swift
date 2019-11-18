//
//  ViewPhotoCollection.swift
//  photoLibs
//
//  Created by Username on 13.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

enum CellHeightEnum: String{

    case zero = "zero"
    case midl = "midl"
    case big = "big"


    var image: UIImage{
        return UIImage(named: self.rawValue) ?? UIImage()
    }

    var size: CGSize {

        let size = SupportClass.Dimensions.wDdevice * 2 / 9
        return CGSize(width: size, height: size)
    }

    var height: CGFloat{
        return self.size.height
    }

}

protocol DelegateSelectedCell: class {
    func pressCell(_ index: IndexPath, rect: CGRect)
}


class ViewPhotoCollection: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var collectionView: UICollectionView!

    private var counterSpecifiedCell = 0
    private let manager = ManagerPhotos.shared

    @IBOutlet weak var imageFront: UIImageView!

    //нажатие и анимац переход
    weak var delegate: DelegateSelectedCell? = nil
    var selectedIndex = IndexPath(row: 0, section: 0)

    var bigUIImage: UIImage? = nil

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
        desingCollectionView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearIndex),
                                               name: .clearIndex,
                                               object: nil)

    }

    func xibSetup() {
        contentView = loadViewFromNib("ViewPhotoCollection")
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
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
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension ViewPhotoCollection: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private func desingCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.backgroundColor = UIColor.clear

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
            let rect = self.collectionView.frameImageView(indexPath)
            self.delegate?.pressCell(indexPath, rect: rect)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CellHeightEnum.midl.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    //в начале

    func startUpdateCollection(){
        if self.imageFront.image == nil {
            self.imageFront.image = self.contentView.screenshot()
            self.imageFront.isUserInteractionEnabled = true
            for obj in self.collectionView.visibleCells {
                obj.contentView.alpha = 0
            }
        }
    }

    //вызываем сразу после свайпов

    func finishUpdateCollection(){
        self.imageFront.image = nil
        self.imageFront.isUserInteractionEnabled = false

        for obj in self.collectionView.visibleCells {
            obj.contentView.alpha = 1
        }
    }

}



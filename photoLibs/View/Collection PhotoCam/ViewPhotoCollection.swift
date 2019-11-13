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
        let koef: CGFloat = self == .big ? 5 : 9
        let size = SupportClass.Dimensions.wDdevice * 2 / koef
        return CGSize(width: size, height: size)
    }

}


class ViewPhotoCollection: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var collectionView: UICollectionView!

    private var counterSpecifiedCell = 0
    private let manager = ManagerPhotos.shared

    var valueEnums = CellHeightEnum.midl


    @IBOutlet weak var imageGestures: UIImageView!
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
        desingCollectionView()

        self.imageGestures.image = valueEnums.image
    }

    func xibSetup() {
        contentView = loadViewFromNib("ViewPhotoCollection")
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return valueEnums.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }

    //в начале

    func startUpdateCollection(){
        self.imageFront.isUserInteractionEnabled = false

    }

    //вызываем сразу после свайпов

    func updateCollection(_ value: CellHeightEnum){
        self.imageFront.isUserInteractionEnabled = true
        self.valueEnums = value
        self.imageGestures.image = valueEnums.image
        self.collectionView.reloadData()
    }

}

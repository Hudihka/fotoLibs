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

        if self == .zero{
            return CGSize(width: 0, height: 0)
        }

        let koef: CGFloat = self == .big ? 5 : 9
        let size = SupportClass.Dimensions.wDdevice * 2 / koef
        return CGSize(width: size, height: size)
    }

    var height: CGFloat{
        return self.size.height
    }

}


class ViewPhotoCollection: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var collectionView: UICollectionView!

    private var counterSpecifiedCell = 0
    private let manager = ManagerPhotos.shared

    var valueEnums: CellHeightEnum? {
        didSet{
            updateCollection()
        }
    }

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

        cell.contentView.addRadius(number: 8)


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
        return valueEnums?.size ?? CellHeightEnum.midl.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    //в начале

    func startUpdateCollection(){
        self.imageFront.image = self.contentView.screenshot()
        self.imageFront.isUserInteractionEnabled = true
    }

    //вызываем сразу после свайпов

    func updateCollection(){
        self.imageFront.image = nil
        self.imageFront.isUserInteractionEnabled = false
        self.collectionView.reloadData()
    }

}


extension UIView {
    func screenshot() -> UIImage {
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: bounds.size).image { _ in
                drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
            drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
            return image
        }
    }

    func addRadius(number: CGFloat) {
        self.layer.cornerRadius = number
        self.layer.masksToBounds = true
    }
}

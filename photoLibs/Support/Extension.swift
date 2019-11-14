//
//  Extension.swift
//  photoLibs
//
//  Created by Username on 14.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


extension UIImage{
    //анимация открытия изображения работает немного криво
    //этим свойством мы получаем финальную позицию изображения
    //относительно его габаритов

    var positionCentrWindovsScaleAspectFill: CGRect {

        let height = SupportClass.Dimensions.wDdevice * self.size.height / self.size.width

        let yPoint = (SupportClass.Dimensions.hDdevice - height) / 2

        return CGRect(x: 0,
                      y: yPoint,
                      width: SupportClass.Dimensions.wDdevice,
                      height: height)
    }
}

extension UIViewController{
    func clearNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }


    func bbCancel(){
        let button = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(exit))
        button.setTitleTextAttributes([.foregroundColor: UIColor.orange], for: .normal)
        button.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .highlighted)
        navigationItem.leftBarButtonItem = button
    }

    @objc func exit(){
        self.dismiss(animated: true, completion: nil)
    }
}


extension UIView {

    @objc func loadViewFromNib(_ name: String) -> UIView { //добавление вью созданной в ксиб файле
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            return view
        } else {
            return UIView()
        }
    }
}


extension UICollectionView{

    func clearImageCell(clear: Bool, index: IndexPath){

        if let cell = self.cellForItem(at: index) as? PhotoCollectionCell {
            if clear {
                cell.imageCell.image = nil
            } else {
                cell.ind = index
            }
        }
    }


    func frameImageView(_ selectedIndex: IndexPath) -> CGRect {


        if let attributes: UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: selectedIndex) {
            let rect = attributes.frame
            let cellFrameInSuperview = self.convert(rect, to: self.superview)

            return cellFrameInSuperview

        }

        return CGRect()

    }

}


extension UIApplication {
    func updateStatusBar(_ clear: Bool){
        let value = clear ? UIWindow.Level.statusBar : UIWindow.Level.normal
        self.keyWindow?.windowLevel = value
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

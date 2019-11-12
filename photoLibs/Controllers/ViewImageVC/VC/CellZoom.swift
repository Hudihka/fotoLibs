//
//  CellZoom.swift
//  testCollection
//
//  Created by Username on 07.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class CellZoom: UICollectionViewCell {

    @IBOutlet weak var spiner: UIActivityIndicatorView!
    var imageScrollView: ImageScrollView!

    var imgBackAnimation: UIImage? = nil //нужно для анимации назад

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear

        self.setupImageScrollView()

    }


    var ind: IndexPath?{
        didSet{
            self.imageScrollView.set(image: nil)
            if let ind = ind {
                ManagerPhotos.shared.getImageOne(indexPath: ind, sizeBig: true) { (img) in
                    self.spiner.stopAnimating()
                    self.imageScrollView.set(image: img)
                    self.imgBackAnimation = img
                }
            }
        }
    }
    

    private func setupImageScrollView() {

        imageScrollView = ImageScrollView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: UIScreen.main.bounds.width,
                                                        height: UIScreen.main.bounds.height))
        self.addSubview(imageScrollView)

        self.imageScrollView.delegateGesture = self
    }
}

extension CellZoom: GestureDelegate{

    func doubleTabGesture() {
        updateNBar(true)
    }

    func tabGesture() {

        updateNBar(false)
    }


    private func updateNBar(_ update: Bool){
        if let VC = UIApplication.shared.getWorkVC() as? ImageZoomVC, VC.flagNavigBarUpdate{
            if update {
                VC.animateHeder(true)
            } else {
                let value = VC.navigBarView.isUserInteractionEnabled
                VC.animateHeder(value)
            }
        }
    }

}

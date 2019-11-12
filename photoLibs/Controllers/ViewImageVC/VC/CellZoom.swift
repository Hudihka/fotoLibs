//
//  CellZoom.swift
//  testCollection
//
//  Created by Username on 07.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class CellZoom: UICollectionViewCell {

    var imageScrollView: ImageScrollView!


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
                    self.imageScrollView.set(image: img)
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
    func zoomGestures() {
        updateNBar(nil)
    }


    func doubleTabGesture() {
        updateNBar(true)
    }

    func tabGesture() {

        updateNBar(false)
    }


    private func updateNBar(_ update: Bool?){
        if let VC = UIApplication.shared.getWorkVC() as? ImageZoomVC, VC.flagNavigBarUpdate{

            guard let update = update else {
                VC.animateHeder(false)
                return
            }


            if update {
                VC.animateHeder(true)
            } else {
                let value = VC.navigBarView.isUserInteractionEnabled
                VC.animateHeder(value)
            }
        }
    }

}

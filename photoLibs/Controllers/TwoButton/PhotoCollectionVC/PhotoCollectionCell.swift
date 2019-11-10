//
//  PhotoCollectionCell.swift
//  tabBarFotoCamera
//
//  Created by Username on 06.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {

    var imgView: UIImageView? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        addViewIMG()
    }


    var ind: IndexPath?{
        didSet{
            update()
        }
    }


    private func update(){

        guard let view = imgView else {
            return
        }

        view.image = UIImage(named: "imgCat")
        if let ind = ind {
            ManagerPhotos.shared.getImageOne(indexPath: ind) { (img) in
                view.image = img
            }
        }
    }

    private func addViewIMG(){

        imgView = UIImageView(frame: self.frame)
        imgView?.contentMode = .scaleAspectFill
        imgView?.image = UIImage(named: "imgCat")


        self.addSubview(imgView ?? UIImageView())

    }

}

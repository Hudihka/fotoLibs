//
//  PhotoCollectionCell.swift
//  tabBarFotoCamera
//
//  Created by Username on 06.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageCell: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }


    var ind: IndexPath?{
        didSet{
            self.imageCell.image = UIImage(named: "imgCat")
            if let ind = ind {
                update(index: ind)
            }
        }
    }


    private func update(index: IndexPath){
        ManagerPhotos.shared.getImageOne(indexPath: index) { (img) in
            self.imageCell.image = img
        }
    }

}

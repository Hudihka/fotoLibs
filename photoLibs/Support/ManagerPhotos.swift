//
//  ManagerLibsUserPhoto.swift
//  tabBarFotoCamera
//
//  Created by Username on 06.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import Photos

class ManagerPhotos: NSObject{

    static let shared = ManagerPhotos()
    let imageCache = NSCache<NSString, UIImage>()

    let height = (SupportClass.Dimensions.wDdevice / 3) - 1
    private let imgManager = PHImageManager.default()

    private var option: PHFetchOptions {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        return fetchOption
    }

    var fetchResult: PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: .image, options: option)
    }

    var requestOption: PHImageRequestOptions{
        let requestOption = PHImageRequestOptions()
        requestOption.isSynchronous = true
        requestOption.deliveryMode = .highQualityFormat

        return requestOption
    }


//    func getImageBig(indexPath: IndexPath, completion: @escaping (UIImage) -> Void){
//
//        let size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//
//        imgManager.requestImage(for: fetchResult.object(at: indexPath.row),
//                                targetSize: size,
//                                contentMode: .aspectFill,
//                                options: requestOption) { (image, _) in
//                                    if let img = image {
//                                        completion(img)
//                                    }
//        }
//    }

    func getImageOne(indexPath: IndexPath, sizeBig: Bool = false, completion: @escaping (UIImage) -> Void){

        let key = indexPath.keyCashIndex

        if let imgCash = imageCache.object(forKey: key){
            completion(imgCash)
            return
        }


        let heig = sizeBig ? SupportClass.Dimensions.hDdevice : height
        let widh = sizeBig ? SupportClass.Dimensions.wDdevice : height
        let size = CGSize(width: widh, height: heig)

        DispatchQueue.global(qos: .userInitiated).async {
            self.imgManager.requestImage(for: self.fetchResult.object(at: indexPath.row),
                                         targetSize: size,
                                         contentMode: .aspectFill,
                                         options: self.requestOption) { (image, _) in
                                            if let img = image {
                                                self.imageCache.setObject(img, forKey: key)
                                                DispatchQueue.main.async {
                                                    completion(img)
                                                }
                                            }
            }
        }
    }

}

extension IndexPath {

    var keyCashIndex: NSString {
        return "Это_ключ_кэш_памяти_\(self.section)-\(self.row)" as NSString
    }

}

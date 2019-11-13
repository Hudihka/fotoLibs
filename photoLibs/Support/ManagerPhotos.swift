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

        let key = indexPath.keyCashIndex(sizeBig)

        if let imgCash = imageCache.object(forKey: key){
            completion(imgCash)
            return
        }

        let heig = sizeBig ? SupportClass.Dimensions.hDdevice : height
        let widh = sizeBig ? SupportClass.Dimensions.wDdevice : height
        let size = CGSize(width: widh, height: heig)

        var receiptFlag = true

        DispatchQueue.global(qos: .userInteractive).async {
            self.imgManager.requestImage(for: self.fetchResult.object(at: indexPath.row),
                                         targetSize: size,
                                         contentMode: .aspectFill,
                                         options: self.requestOption) { (image, _) in
                                            if let img = image {
                                                self.imageCache.setObject(img, forKey: key)
                                                DispatchQueue.main.async {
                                                    if receiptFlag {
                                                        completion(img)
                                                        receiptFlag = false
                                                    }
                                                }
                                            }
            }
        }

        if sizeBig {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                if receiptFlag {
                    self.getImageOne(indexPath: indexPath, completion: { (img) in
                        if receiptFlag {
                            completion(img)
                            receiptFlag = false
                        }
                    })
                }
            }
        }
    }


    private func getImageTimeSmall(indexPath: IndexPath, completion: @escaping (UIImage) -> Void){

        let key = indexPath.keyCashIndex(false)

        if let imgCash = imageCache.object(forKey: key){
            completion(imgCash)
            return
        }

        let size = CGSize(width: height, height: height)

        DispatchQueue.global(qos: .userInteractive).async {
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

    func keyCashIndex( _ isBig: Bool) -> NSString {
        let value = isBig ? "Большая" : "Маленька"

        return "Это_ключ_кэш_памяти_\(value)_\(self.section)-\(self.row)" as NSString
    }

}

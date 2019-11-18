//
//  MaskCircleView.swift
//  OpenCircleAnimate
//
//  Created by Username on 17.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class MaskCircleView: UIView {

    var startPoint: CGPoint? = nil //если из маленького в большое
    var finishPoint: CGPoint? = nil

    private var zeroFrame = CGRect(x: 0, y: 0, width: 0, height: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.​configure()
    }

    private var startFrame: CGRect {
        if let startPoint = startPoint {
            return CGRect(origin: startPoint, size: CGSize(width: 0, height: 0))
        } else if let finishPoint = finishPoint {
            return finishPoint.bigSizeInPoint
        }

        return zeroFrame
    }

    private var finalFrame: CGRect {
        if let finishPoint = finishPoint {
            return CGRect(origin: finishPoint, size: CGSize(width: 0, height: 0))
        } else if let startPoint = startPoint {
            return startPoint.bigSizeInPoint
        }

        return zeroFrame
    }


    func ​configure(){

        let myClippingPath = UIBezierPath(ovalIn: startFrame).cgPath
        let mask = CAShapeLayer()
        mask.path = myClippingPath
        superview?.layer.mask = mask

        let toPath = UIBezierPath(ovalIn: finalFrame).cgPath

        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.delegate = self
        pathAnimation.fromValue = myClippingPath
        pathAnimation.toValue = toPath
        pathAnimation.duration = 0.3
        mask.add(pathAnimation, forKey: pathAnimation.keyPath)


    }

}

//можно сделать пмросто через функцию завершения тогда противное мигание

extension MaskCircleView: CAAnimationDelegate {

    func animationDidStart(_ anim: CAAnimation) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if self.startPoint != nil {
                self.superview?.layer.mask = nil
            } else {
                self.superview?.removeFromSuperview()
            }
        }
    }

}




extension CGRect{

    var radiusMax: CGFloat {

        let point0 = self.origin

        let point00 = CGPoint(x: 0, y: 0)

        let point0max = CGPoint(x: 0,
                                y: SupportClass.Dimensions.hDdevice)

        let pointmax0 = CGPoint(x: SupportClass.Dimensions.wDdevice,
                                y: 0)

        let pointMaxMax = CGPoint(x: SupportClass.Dimensions.wDdevice,
                                  y: SupportClass.Dimensions.hDdevice)


        let radius1 = point0.distance(point00)//, point00)
        let radius2 = point0.distance(pointmax0)
        let radius3 = point0.distance(point0max)
        let radius4 = point0.distance(pointMaxMax)


        let value = max(max(radius1, radius2), max(radius3, radius4))

        return value
    }


    var bigRect: CGRect {

        let point0 = self.origin
        let radiys = radiusMax

        return CGRect(x: point0.x - radiys,
                      y: point0.y - radiys,
                      width: 2 * radiys,
                      height: 2 * radiys)

    }

}


extension CGPoint {

    func distance( _ b: CGPoint) -> CGFloat {
        let xDist = self.x - b.x
        let yDist = self.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }

    var bigSizeInPoint: CGRect {

        let zeroSize = CGRect(origin: self, size: CGSize(width: 0, height: 0))
        return zeroSize.bigRect

    }

}


//
//  IZoomScroll.swift
//  photoLibs
//
//  Created by Username on 15.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit


extension ImageZoomVC: UIScrollViewDelegate {


    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        отпустил палец
        reloadCounter(velocity)
        targetContentOffset.pointee.x = UIScreen.main.bounds.size.width * CGFloat(counter)
        textTitle()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { //анимация скролинга началась
        flagAnimateCollection = false

        if activeNB {
            self.timer.invalidate()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){ //анимация скролинга закончилась
        flagAnimateCollection = true

        if activeNB {
            self.startTimer()
        }
    }


    private func reloadCounter(_ velocity: CGPoint) {

        SupportNotification.notificClearImage(index: IndexPath(row: counter, section: 0), isClear: false)

        if velocity.x < 0 {
            if counter != 0 {
                counter -= 1
            }
        } else if velocity.x > 0 {
            if counter != countCell - 1 {
                counter += 1
            }
        }
        SupportNotification.notificClearImage(index: IndexPath(row: counter, section: 0), isClear: true)

    }

    var activeNB: Bool{
        return self.navigBarView.isUserInteractionEnabled
    }

}

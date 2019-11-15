//
//  IZoomTimer.swift
//  photoLibs
//
//  Created by Username on 15.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import Foundation
import UIKit

extension ImageZoomVC {

    func startTimer() {

        time = 5

        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(ImageZoomVC.actionTimer),
                                          userInfo: nil,
                                          repeats: true)
    }

    @objc func actionTimer() {
        self.time -= 1

        print(time)

        if self.time == 0 {
            if activeNB {
                self.animateHeder(true)
            }
            self.timer.invalidate()
        }
    }


}

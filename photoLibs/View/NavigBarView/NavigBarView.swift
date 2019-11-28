//
//  NavigBarView.swift
//  testCollection
//
//  Created by Username on 07.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit


class NavigBarView: UIView {
    @IBOutlet weak var conteinerView: UIView!

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!

    @IBOutlet weak var labelTitle: UILabel!

    override init (frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        settingsView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        settingsView()
    }

    private func settingsView() {
        self.conteinerView.backgroundColor = UIColor.clear

        desingButton()
        colorNB(value: 1)
    }

    func xibSetup() {
        conteinerView = loadViewFromNib("NavigBarView")
        conteinerView.frame = bounds
        conteinerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(conteinerView)
    }


    private func clearView( _ clear: Bool) {

        self.rightButton.isHidden = clear
        self.leftButton.isHidden = clear
        self.labelTitle.isHidden = clear

    }

    func colorNB(value: CGFloat){

        let colorWhite = UIColor(red: 1, green: 1, blue: 1, alpha: value)

        let alpha = value >= 0.3 ? value - 0.3 : 0
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)

        self.rightButton.alpha = value
        self.leftButton.alpha = value

        self.labelTitle.textColor = colorWhite

        self.clearView(value == 0.0)
    }




    private func desingButton(){

        leftButton.setTitle("Отмена", for: .normal)
        rightButton.setTitle("Выбрать", for: .normal)
    }

    //MARK: - ACTION

    @IBAction func leftButtonAction(_ sender: Any) { //отмена
        if let vc = UIApplication.shared.getWorkVC as? ImageZoomVC {
            vc.killVC()
        }
    }

    @IBAction func rightButtonAction(_ sender: Any) { //кнопка выбора

        guard let activeVC = UIApplication.shared.getWorkVC as? ImageZoomVC,
              let img = activeVC.imageActive else {
            return
        }

        SupportNotification.notificImage(img)

        activeVC.dismiss(animated: true) {
            if let lastPushVC = UIApplication.shared.lastPushVC {
                if FrieButtonVC.openNevStackNavigation {
                    lastPushVC.dismiss(animated: true, completion: nil) //камера/выбираем фото из коллекции
                } else {
                    UIApplication.shared.getWorkVC.navigationController?.popViewController(animated: true) //фото/выбираем фото
                }
            }
        }
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



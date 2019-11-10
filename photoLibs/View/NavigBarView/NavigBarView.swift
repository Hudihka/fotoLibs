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
        clearView(false)
    }

    func xibSetup() {
        conteinerView = loadViewFromNib("NavigBarView")
        conteinerView.frame = bounds
        conteinerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(conteinerView)
    }


    func clearView( _ clear: Bool) {

        self.rightButton.isHidden = clear
        self.leftButton.isHidden = clear
        self.labelTitle.isHidden = clear

        let alpha: CGFloat = clear ? 0 : 0.5
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)

    }


    private func desingButton(){

        leftButton.setTitle("Отмена", for: .normal)
        leftButton.setTitle("Выбрать", for: .normal)
    }

    //MARK: - ACTION

    @IBAction func leftButtonAction(_ sender: Any) {
    }

    @IBAction func rightButtonAction(_ sender: Any) {
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIView {
    @objc func loadViewFromNib(_ name: String) -> UIView { //добавление вью созданной в ксиб файле
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            return view
        } else {
            return UIView()
        }
    }
}

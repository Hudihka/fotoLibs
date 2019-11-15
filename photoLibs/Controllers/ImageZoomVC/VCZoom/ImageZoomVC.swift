//
//  ImageVC.swift
//  testCollection
//
//  Created by Username on 07.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

//protocol DelegateReloadSelectedCell: class {
//    func reloadCell(index: IndexPath, isSclear: Bool)
//}

class ImageZoomVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigBarView: NavigBarView!

    var counter = 0
    var imageCellOne: UIImage? = nil

    static var positionY: CGFloat = 0

    var countCell: Int{
        return ManagerPhotos.shared.fetchResult.count
    }

    var finishAnimate = true
    var flagAnimateCollection = true
    var flagNavigBarUpdate = true


    lazy var swipeGesture: UIPanGestureRecognizer = {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(swipeSelector))
        swipe.minimumNumberOfTouches = 1
        return swipe
    }()


    //TIMER

    var timer = Timer()
    var time = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        settingsCV()


        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrolling()
        }

        self.collectionView.addGestureRecognizer(self.swipeGesture)
        self.collectionView.isUserInteractionEnabled = true
        self.swipeGesture.delegate = self

//        self.swipeGesture.cancelsTouchesInView = false

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        startTimer()

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    private func scrolling(){
        self.collectionView.scrollToItem(at: IndexPath(row: self.counter, section: 0), at: .left, animated: false)
        textTitle()
    }

    func textTitle(){
        let text = imageCellOne != nil ? "" : "\(counter + 1) из \(countCell)"
        self.navigBarView.labelTitle.text = text
    }

    static func route(index: Int, image: UIImage? = nil) -> ImageZoomVC? {
        let VC = UIStoryboard(name: "ImageStoryboard", bundle: nil).instantiateInitialViewController() as? ImageZoomVC

        VC?.counter = index
        VC?.imageCellOne = image
        return VC
    }

    //swipe

    @objc func swipeSelector(sender: UIPanGestureRecognizer) {
        if ImageScrollView.originalFrame && self.finishAnimate && flagAnimateCollection{

            collectionView.isScrollEnabled = false

            let translatedPoint = sender.translation(in: self.view)

            let newTranslatedPoint = CGPoint(x: 0, y: translatedPoint.y)

            ImageZoomVC.positionY = translatedPoint.y

            let value = abs(newTranslatedPoint.y)

            switch sender.state {
            case .began, .changed:
                sender.view?.frame.origin.y = newTranslatedPoint.y
                alphaBacground(value: value)

            case .ended:
                dismiss(value: value)
//                self.blockCell(true)
            default:
                break
            }
        }
    }


    private func originalPosition(){
        finishAnimate = false
        UIView.animate(withDuration: 0.3, animations: {

            self.collectionView.frame = CGRect(x: 0,
                                               y: 0,
                                               width: self.collectionView.frame.width,
                                               height: self.collectionView.frame.height)

            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            self.alphaBacground(value: 1)

        }) { (comp) in
            if comp {
                self.finishAnimate = true
                self.collectionView.isScrollEnabled = true
            }
        }
    }


    private func alphaBacground(value: CGFloat){

        let alpha = ImageZoomVC.alphaContent(value: value)
        self.view.backgroundColor = UIColor(red: 0,
                                            green: 0,
                                            blue: 0,
                                            alpha: alpha)

        self.navigBarView.colorNB(value: alpha)

    }

    static func alphaContent(value: CGFloat) -> CGFloat{
        return value >= 100 ? 0 : (100 - value)/100
    }


    private func dismiss(value: CGFloat){
        if value > 100{
            self.killVC()
        } else {
            originalPosition()
        }
    }


    func animateHeder(_ clear: Bool){

        self.flagNavigBarUpdate = false
        let alpha: CGFloat = clear ? 0 : 1

        UIView.animate(withDuration: 0.25, animations: {
            self.navigBarView.colorNB(value: alpha)
            UIApplication.shared.updateStatusBar(clear)
        }) { (comp) in
            if comp {
                self.navigBarView.isUserInteractionEnabled = !clear
                self.flagNavigBarUpdate = true

                if !clear {
                    self.startTimer()
                }
            }
        }
    }

    func killVC(){
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }



}






extension ImageZoomVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{

        return true
    }

}



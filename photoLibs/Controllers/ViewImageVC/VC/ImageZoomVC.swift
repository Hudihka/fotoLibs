//
//  ImageVC.swift
//  testCollection
//
//  Created by Username on 07.11.2019.
//  Copyright © 2019 Username. All rights reserved.
//

import UIKit

class ImageZoomVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigBarView: NavigBarView!

    var counter = 0

    var countCell: Int{
        return ManagerPhotos.shared.fetchResult.count
    }

    private var finishAnimate = true
    private var flagAnimateCollection = true
    var flagNavigBarUpdate = true


    lazy var swipeGesture: UIPanGestureRecognizer = {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(swipeSelector))
        swipe.minimumNumberOfTouches = 1
        return swipe
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        settingsCV()


        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrolling()
        }

        self.collectionView.addGestureRecognizer(self.swipeGesture)
        self.collectionView.isUserInteractionEnabled = true
        self.swipeGesture.delegate = self

        self.swipeGesture.cancelsTouchesInView = false

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    private func scrolling(){
        self.collectionView.scrollToItem(at: IndexPath(row: self.counter, section: 0), at: .left, animated: false)
        textTitle()
    }

    private func textTitle(){
        self.navigBarView.labelTitle.text = "\(counter + 1) из \(countCell)"
    }

    static func route(index: Int) -> ImageZoomVC? {
        let VC = UIStoryboard(name: "ImageStoryboard", bundle: nil).instantiateInitialViewController() as? ImageZoomVC

        VC?.counter = index
        return VC
    }

    //swipe

    @objc func swipeSelector(sender: UIPanGestureRecognizer) {
        if ImageScrollView.originalFrame && self.finishAnimate && flagAnimateCollection{

            collectionView.isScrollEnabled = false
//            self.blockCell(false)

            let translatedPoint = sender.translation(in: self.view)

            let newTranslatedPoint = CGPoint(x: 0, y: translatedPoint.y)

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


//    private func blockCell(_ enabled: Bool){
//
//        if let cell = self.collectionView.cellForItem(at: IndexPath(row: counter, section: 0)) as? CellZoom{
//            cell.imageScrollView.isScrollEnabled = enabled
//        }
//    }

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

        let alpha: CGFloat = value >= 100 ? 0 : (100 - value)/100
        self.view.backgroundColor = UIColor(red: 0,
                                            green: 0,
                                            blue: 0,
                                            alpha: alpha)

        self.navigBarView.colorNB(value: alpha)

    }


    private func dismiss(value: CGFloat){
        if value > 100{
            UIApplication.shared.setStatusBarStyle(.default, animated: true)
            UIApplication.shared.updateStatusBar(false)
            self.dismiss(animated: true, completion: nil)
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
            }
        }
    }


}


extension ImageZoomVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - CollectionView

    func settingsCV() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        self.collectionView.register(UINib(nibName: "CellZoom", bundle: nil),
                                     forCellWithReuseIdentifier: "CellZoom")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countCell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellZoom = collectionView.dequeueReusableCell(withReuseIdentifier: "CellZoom", for: indexPath) as! CellZoom

        cell.ind = indexPath

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width,
                      height: UIScreen.main.bounds.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension ImageZoomVC: UIScrollViewDelegate {

    //заканчивает

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        reloadCounter(velocity)
        targetContentOffset.pointee.x = UIScreen.main.bounds.size.width * CGFloat(counter)
        textTitle()
        print("end scroll")
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        flagAnimateCollection = false
        print("start scroll")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        flagAnimateCollection = true
    }


    private func reloadCounter(_ velocity: CGPoint) {
        if velocity.x < 0 {
            if counter != 0 {
                counter -= 1
            }
        } else if velocity.x > 0 {
            if counter != countCell - 1 {
                counter += 1
            }
        }
    }

}


extension ImageZoomVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{

        return true
    }

}

extension UIApplication {
    func updateStatusBar(_ clear: Bool){
        let value = clear ? UIWindow.Level.statusBar : UIWindow.Level.normal
        self.keyWindow?.windowLevel = value
    }
}


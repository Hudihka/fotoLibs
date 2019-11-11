


import UIKit

let animationTimeInterval: TimeInterval = 0.4

class PresentStockAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let originFrame: CGRect
    private let image: UIImage

    init(originFrame: CGRect, image: UIImage) {
        self.originFrame = originFrame
        self.image = image
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTimeInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

//        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) // до, вью контроллер с изображением
//         let fromVC = transitionContext.viewController(forKey: .from),  // из, вью контроллер с коллекцией

        guard let toVC = transitionContext.viewController(forKey: .to) as? TwoViewController     // до, вью контроллер с изображением
            else {
                return
        }

        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.red
        let finalFrame = CGRect(x: 0, y: 0, width: Dimensions.wDdevice, height: Dimensions.wDdevice * 87/125 )


        let snaphot = UIImageView(frame: originFrame)
        snaphot.clipsToBounds = true
        snaphot.contentMode = .scaleAspectFill
        snaphot.addRadius(number: 8)
        snaphot.layer.masksToBounds = true
        snaphot.image = self.image

//        snapshot.frame = originFrame            //это начальное изображение из
//        snapshot.addRadius(number: 8)
//        snapshot.backgroundColor = UIColor.black
//        snapshot.layer.masksToBounds = true

        containerView.addSubview(toVC.view)     //в начале в контейнер добавляем конечный
        containerView.addSubview(snaphot)      //а сверху кладем снимок экрана с табл, тк потом экран с таблицей анимац расстворится

        toVC.view.alpha = 0
        toVC.imageV.image = nil
//        toVC.view.isHidden = true

        UIView.animate(withDuration: animationTimeInterval, animations: {
            snaphot.addRadius(number: 0)
            toVC.view.alpha = 1
            snaphot.frame = finalFrame
        }) { [weak self] (compl) in
            if compl == true{

                toVC.imageV.image = self?.image
                snaphot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}


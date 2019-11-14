


import UIKit

let animationTimeInterval: TimeInterval = 0.25

class PresentZoomVCAnimation: NSObject, UIViewControllerAnimatedTransitioning {

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

        guard let toVC = transitionContext.viewController(forKey: .to) as? ImageZoomVC, // до, вью контроллер с изображением
            let navBar = toVC.navigBarView else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear


        let snaphot = UIImageView(frame: originFrame)
        snaphot.image = self.image
        snaphot.contentMode = .scaleAspectFill
        snaphot.clipsToBounds = true


        if transitionContext.viewController(forKey: .from) is UINavigationController {
            snaphot.addRadius(number: 8)
        }

        toVC.collectionView.isHidden = true
        toVC.view.alpha = 0
        navBar.alpha = 0

        containerView.addSubview(toVC.view)     //в начале в контейнер добавляем конечный
        containerView.addSubview(snaphot)       //а сверху кладем снимок экрана с табл, тк потом экран с таблицей анимац расстворится


        UIView.animate(withDuration: animationTimeInterval, animations: {
            navBar.alpha = 1
            containerView.backgroundColor = UIColor.black
            snaphot.frame = self.image.positionCentrWindovsScaleAspectFill
            snaphot.addRadius(number: 0)
        }) { (compl) in
            if compl == true{

                toVC.view.alpha = 1
                containerView.backgroundColor = UIColor.clear
                toVC.collectionView.isHidden = false
                snaphot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}


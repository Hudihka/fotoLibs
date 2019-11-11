



import UIKit

protocol GestureDelegate: class {
    func tabGesture()
    func doubleTabGesture()
    func zoomGesters()
}

class ImageScrollView: UIScrollView, UIScrollViewDelegate {

    var imageZoomView: UIImageView!
    weak var delegateGesture: GestureDelegate?

    static var originalFrame: Bool = true
    
    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()

    lazy var oneTap: UITapGestureRecognizer = {
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(tabDetected))
        oneTap.numberOfTapsRequired = 1
        return oneTap
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast

        self.isScrollEnabled = false
        ImageScrollView.originalFrame = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: UIImage?) {
        
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        imageZoomView = UIImageView(image: image)
        imageZoomView.contentMode = .scaleAspectFill
        self.addSubview(imageZoomView)

        if let img = image{
            configurateFor(imageSize: img.size)
            self.isScrollEnabled = true
        } else {
            configurateFor(imageSize: CGSize(width: SupportClass.Dimensions.wDdevice,
                                             height: SupportClass.Dimensions.wDdevice))
        }

    }
    
    func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize
        
        setCurrentMaxandMinZoomScale()
        self.zoomScale = self.minimumZoomScale
        
        self.imageZoomView.addGestureRecognizer(self.zoomingTap)
        self.imageZoomView.isUserInteractionEnabled = true


        self.imageZoomView.addGestureRecognizer(self.oneTap)
        self.imageZoomView.isUserInteractionEnabled = true

        oneTap.require(toFail: zoomingTap)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.centerImage()
    }
    
    func setCurrentMaxandMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageZoomView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }
    
    func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageZoomView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageZoomView.frame = frameToCenter
    }
    
    // gesture
    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        self.delegateGesture?.doubleTabGesture()
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }

    @objc func tabDetected(sender: UITapGestureRecognizer) {
        delegateGesture?.tabGesture()
    }
    
    func zoom(point: CGPoint, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let value = currectScale == minScale

        print(currectScale)

        ImageScrollView.originalFrame = !value
        let finalScale = value ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
        self.delegateGesture?.doubleTabGesture()
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds


        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        print(zoomRect)
        return zoomRect
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("start zoom")
        return self.imageZoomView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("finish zoom")
        self.centerImage()
    }


    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?){
        ImageScrollView.originalFrame = false
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat){
        ImageScrollView.originalFrame = true
    }
}

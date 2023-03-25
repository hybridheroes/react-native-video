import AVKit

class RCTVideoPlayerViewController: AVPlayerViewController {
    
    var rctDelegate:RCTVideoPlayerViewControllerDelegate!
    
    // Optional paramters
    var preferredOrientation:String?
    var autorotate:Bool?
    var onVideoPlayerOrientationChange: RCTDirectEventBlock?
    
    func shouldAutorotate() -> Bool {

        if autorotate! || preferredOrientation == nil || (preferredOrientation!.lowercased() == "all") {
            return true
        }

        return false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if rctDelegate != nil {
            rctDelegate.videoPlayerViewControllerWillDismiss(playerViewController: self)
            rctDelegate.videoPlayerViewControllerDidDismiss(playerViewController: self)
        }
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    #if !TARGET_OS_TV
    
    @objc func deviceOrientationDidChange() {
        let orientation = UIDevice.current.orientation
        // Handle device orientation change
        // Numbers refer to Expo Scree Orientation types:
        // https://docs.expo.dev/versions/latest/sdk/screen-orientation#orientation
        switch orientation {
        case .portrait:
            onVideoPlayerOrientationChange!([ "orientation": NSNumber(value: 1) ])
        case .portraitUpsideDown:
            onVideoPlayerOrientationChange!([ "orientation": NSNumber(value: 2) ])
        case .landscapeLeft:
            onVideoPlayerOrientationChange!([ "orientation": NSNumber(value: 3) ])
        case .landscapeRight:
            onVideoPlayerOrientationChange!([ "orientation": NSNumber(value: 4) ])
        default:
            onVideoPlayerOrientationChange!([ "orientation": NSNumber(value: 0) ])
        }
    }

    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .all
    }

    func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if preferredOrientation?.lowercased() == "landscape" {
            return .landscapeRight
        } else if preferredOrientation?.lowercased() == "portrait" {
            return .portrait
        } else {
            // default case
            let orientation = UIApplication.shared.statusBarOrientation
            return orientation
        }
    }
    #endif
}

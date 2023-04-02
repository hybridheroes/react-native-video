//
//  RCTPlayerDelegate.swift
//
import UIKit
import AVKit
import AVFoundation

@available(iOS 9.0, *)
class RCTPlayerDelegate: NSObject, AVPlayerViewControllerDelegate {
    
    private var _onPictureInPictureStatusChanged: RCTDirectEventBlock?
    private var _onVideoFullscreenPlayerWillPresent: RCTDirectEventBlock?
    private var _onVideoFullscreenPlayerWillDismiss: RCTDirectEventBlock?
    private var _onVideoFullscreenPlayerDidDismiss: RCTDirectEventBlock?
        
    init(_ onPictureInPictureStatusChanged: RCTDirectEventBlock?, _ onVideoFullscreenPlayerWillPresent: RCTDirectEventBlock?, _ onVideoFullscreenPlayerWillDismiss: RCTDirectEventBlock?, _ onVideoFullscreenPlayerDidDismiss: RCTDirectEventBlock?) {
        _onPictureInPictureStatusChanged = onPictureInPictureStatusChanged
        _onVideoFullscreenPlayerWillPresent = onVideoFullscreenPlayerWillPresent
        _onVideoFullscreenPlayerWillDismiss = onVideoFullscreenPlayerWillDismiss
        _onVideoFullscreenPlayerDidDismiss = onVideoFullscreenPlayerDidDismiss
    }
    
    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
        _onPictureInPictureStatusChanged!([ "isActive": NSNumber(value: true) ])
        
    }
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
        _onPictureInPictureStatusChanged!([ "isActive": NSNumber(value: false) ])
        
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator) {

        _onVideoFullscreenPlayerWillPresent?([:])
        
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self._onVideoFullscreenPlayerDidDismiss?([:])
                })
        
        _onVideoFullscreenPlayerWillDismiss?([:])
        
    }
    
}

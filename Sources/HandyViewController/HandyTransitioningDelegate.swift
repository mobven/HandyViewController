//
//  Transitioning.swift
//  HandyViewControllerSamples
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

public final class HandyTransitioningDelegate: NSObject {
    
    internal weak var scrollViewDelegate: HandyScrollViewDelegate?
    internal var contentMode: ContentMode = .contentSize
    
    public init(from presented: UIViewController, to presenting: UIViewController,
                contentMode: ContentMode = .contentSize) {
        super.init()
        self.contentMode = contentMode
    }
    
}

extension HandyTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        var safeAreaInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeAreaInsets = source.view.safeAreaInsets
        } else {
            safeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        let controller = HandyPresentationController(presentedViewController: presented,
                                                     presenting: presenting,
                                                     safeAreaInsets: safeAreaInsets,
                                                     contentMode: contentMode)
        scrollViewDelegate = controller
        return controller
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}

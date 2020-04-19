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
    
    public init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
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
        let controller = HandyPresentationController(presentedViewController: presented, presenting: presenting)
        scrollViewDelegate = controller
        return controller
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}

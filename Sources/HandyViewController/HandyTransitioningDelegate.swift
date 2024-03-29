//
//  Transitioning.swift
//  HandyViewControllerSamples
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

public final class HandyTransitioningDelegate: NSObject {
    
    internal weak var scrollViewContentSizeDelegate: HandyScrollViewContentSizeDelegate?
    internal var contentMode: ContentMode = .contentSize
    internal var scrollView: UIScrollView?
    internal var stackView: UIStackView?
    internal var syncViewHeightWithKeyboard: Bool = true
    internal var maxBackgroundOpacity: CGFloat = 0.5
    internal var presentedViewControllerRadius: CGFloat = 10
    
    /// Initializes transitioing delegate.
    /// - parameter presented: View controller presenting HandyViewController.
    /// - parameter presenting: View controller being presented.
    /// - parameter contentMode: Content mode of HandyViewController.
    /// - parameter syncViewHeightWithKeyboard: When the keyboard is showed, view scrolls up with the keyboard.
    /// - parameter maxBackgroundOpacity: Change background dim opacity, set zero to turn it off.
    public init(
        from presented: UIViewController,
        to presenting: UIViewController,
        contentMode: ContentMode = .contentSize,
        syncViewHeightWithKeyboard: Bool = true,
        maxBackgroundOpacity: CGFloat = 0.5,
        presentedViewControllerRadius: CGFloat = 10
    ) {
        super.init()
        self.contentMode = contentMode
        self.presentedViewControllerRadius = presentedViewControllerRadius
        self.syncViewHeightWithKeyboard = syncViewHeightWithKeyboard
        self.maxBackgroundOpacity = maxBackgroundOpacity
    }
    
    internal func registerHandyScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        if let scrollViewContentSizeDelegate = scrollViewContentSizeDelegate {
            scrollViewContentSizeDelegate.registerHandyScrollView(scrollView)
        }
    }
    
    internal func registerHandyStackView(_ stackView: UIStackView) {
        self.stackView = stackView
        if let scrollViewContentSizeDelegate = scrollViewContentSizeDelegate {
            scrollViewContentSizeDelegate.registerHandyStackView(stackView)
        }
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

        let safeAreaInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? source.view.safeAreaInsets
        } else {
            safeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        let controller = HandyPresentationController(presentedViewController: presented,
                                                     presenting: presenting,
                                                     safeAreaInsets: safeAreaInsets,
                                                     contentMode: contentMode,
                                                     syncViewHeightWithKeyboard: syncViewHeightWithKeyboard,
                                                     maxBackgroundOpacity: maxBackgroundOpacity,
                                                     cornerRadius: presentedViewControllerRadius
        )
        scrollViewContentSizeDelegate = controller
        if let scrollView = scrollView {
            scrollViewContentSizeDelegate?.registerHandyScrollView(scrollView)
        }
        if let stackView = stackView {
            scrollViewContentSizeDelegate?.registerHandyStackView(stackView)
        }
        return controller
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}

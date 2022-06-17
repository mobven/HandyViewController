//
//  HandyPresentationController.swift
//  HandyViewController
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

final class HandyPresentationController: UIPresentationController {
    
    /// Safe area insets of source view controller.
    private var safeAreaInsets: UIEdgeInsets
    /// Content mode for the presented view controller.
    private var contentMode: ContentMode = .contentSize
    
    private let maxBackgroundOpacity: CGFloat = 0.5
    
    /// Calculated content height of the presented view controller's root view, excluding `scrollViewHeight`.
    private var contentHeight: CGFloat!
    /// Calculated content height of the scrollView.
    private var scrollViewHeight: CGFloat = 0
    /// Workaround for scrollView contentSize being called multiple times.
    /// Default value is -1, indicating, there was no change in content size for last 0.1 second.
    private var temporaryScrollViewHeight: CGFloat = -1
    
    /// Height constraint of the presented view controller's root view.
    /// Changes depending on `contentHeight` and `scrollViewHeight`
    private var contentHeightConstraint: NSLayoutConstraint?
    /// Top constraint of the presented view controller's root view.
    private weak var topConstraint: NSLayoutConstraint?
    /// Height constraint of the scroll view. Changes depending on `scrollViewHeight`
    private weak var scrollViewHeightConstraint: NSLayoutConstraint?
    /// If you don't want to resize of the bottom sheet with the keyboard movement, choose false.....
    private var syncViewHeightWithKeyboard: Bool = true
    
    private var isSwipableAnimating: Bool = false
    
    private var contentSizeObserver: NSKeyValueObservation?
    
    private var isKeyboardShown: Bool = false
    
    private var keyboardHeight: CGFloat = 0
    
    private enum SheetType {
        case scrollView, stackView
    }
    
    private var sheetType: SheetType?

    /// Background dim view with alpha value `maxBackgroundOpacity`.
    private lazy var backgroundDimView: UIView! = {
        guard let container = containerView else { return nil }
        
        let view = UIView(frame: container.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(maxBackgroundOpacity)
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundDim(_:)))
        )
        view.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        )
        
        return view
    }()
    
    /// Initializes and returns a presentation controller for transitioning between the specified view controllers
    ///
    /// - Parameters:
    ///   - presentedViewController: The view controller being presented modally.
    ///   - presenting: The view controller whose content represents the starting point of the transition.
    ///   - safeAreaInsets: Safe area insets of source view controller.
    ///   Discussion: During initialization, both presented and presenting view controller have zero `safeAreaInsets`,
    ///   as they're in presentation. That's why, it's added in initializer of `HandyPresentationController`,
    ///   to receive insets from source controller.
    ///   - contentMode: Content mode for the presented view controller.
    required init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?,
                  safeAreaInsets: UIEdgeInsets,
                  contentMode: ContentMode,
                  syncViewHeightWithKeyboard: Bool) {
        self.contentMode = contentMode
        self.safeAreaInsets = safeAreaInsets
        self.syncViewHeightWithKeyboard = syncViewHeightWithKeyboard
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        presentedViewController.view.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        )
        
        presentedViewController.view.layer.cornerRadius = 10
        presentedViewController.view.layer.masksToBounds = true
        presentedViewController.view.translatesAutoresizingMaskIntoConstraints = false
        presentedViewController.view.widthAnchor.constraint(
            equalToConstant: UIScreen.main.bounds.width
        ).isActive = true
        
        if contentMode == .fullScreen {
            contentHeight = UIScreen.main.bounds.height - minimumTopDistance
        } else {
            contentHeight = presentedViewController.view.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            ).height + minimumTopDistance
        }
        contentHeightConstraint = presentedViewController.view.heightAnchor.constraint(
            equalToConstant: contentHeight
        )
        contentHeightConstraint?.isActive = true
        
        if contentMode == .contentSize, syncViewHeightWithKeyboard {
            addKeyboardObservers()
        }
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    deinit {
        contentSizeObserver?.invalidate()
        contentSizeObserver = nil
        if contentMode == .contentSize {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func updateTopDistance() {
        guard let container = containerView else { return }
        
        if topConstraint != nil {
            if topConstraint?.constant != topDistance {
                topConstraint?.constant = topDistance - safeAreaInsets.bottom - safeAreaInsets.top
                animateDamping {
                    container.layoutIfNeeded()
                }
            }
        } else {
            topConstraint = presentedViewController.view.topAnchor.constraint(
                equalTo: topAnchor, constant: topDistance - safeAreaInsets.bottom - safeAreaInsets.top
            )
            topConstraint?.isActive = true
        }
    }
    
    private var minimumTopDistance: CGFloat {
        if safeAreaInsets.top == 0 {
            return 20
        }
        return safeAreaInsets.top
    }
    
    private var topAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return containerView!.safeAreaLayoutGuide.topAnchor
        } else {
            return containerView!.topAnchor
        }
    }
    
    private var topDistance: CGFloat {
        let distance = UIScreen.main.bounds.height - contentHeight - scrollViewHeight + minimumTopDistance
        if distance < 0 {
            return minimumTopDistance
        }
        return distance
    }
    
    // MARK: - Gestures
    @objc func didPan(_ panGesture: UIPanGestureRecognizer) {
        guard let view = panGesture.view, let contentView = view.superview else { return }
        let translation = panGesture.translation(in: contentView)
        
        if panGesture.state == .changed {
            guard translation.y > 0 else { return }
            animatePanChange(translationY: translation.y)
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: contentView)
            animatePanEnd(velocityCheck: velocity.y >= 1500)
        }
    }
    
    private func animatePanChange(translationY: CGFloat) {
        guard let presented = presentedView else { return }
        presented.frame.origin.y = topDistance - safeAreaInsets.bottom + translationY * 0.7 // speed
        let yVal = (UIScreen.main.bounds.height - presented.frame.origin.y) / (presented.frame.height + keyboardHeight)
        backgroundDimView.backgroundColor = UIColor(
            white: 0, alpha: yVal - maxBackgroundOpacity
        )
    }
    
    private func animatePanEnd(velocityCheck: Bool) {
        guard let presented = presentedView else { return }
        if velocityCheck {
            dismiss()
        } else if (UIScreen.main.bounds.height - presented.frame.origin.y + minimumTopDistance) <
                    presented.frame.height / 2 {
            dismiss()
        } else {
            isSwipableAnimating = true
            animateDamping { [ weak self ] in
                guard let self = self else { return }
                guard let presented = self.presentedView else { return }
                presented.frame.origin = CGPoint(
                    x: 0, y: self.topDistance - self.safeAreaInsets.bottom
                )
                self.backgroundDimView.backgroundColor = UIColor(
                    white: 0, alpha: self.maxBackgroundOpacity
                )
                self.setSwipableAnimatingWithDelay()
            }
        }
    }
    
    private func dismiss() {
        isSwipableAnimating = true
        UIView.animate(withDuration: 0.2, animations: { [ weak self ] in
            guard let self = self else { return }
            guard let presented = self.presentedView else { return }
            self.backgroundDimView.alpha = 0
            presented.frame.origin = CGPoint(
                x: presented.frame.origin.x,
                y: UIScreen.main.bounds.height
            )
        }, completion: { [ weak self ] (isCompleted) in
            if isCompleted {
                self?.presentedViewController.dismiss(animated: false, completion: nil)
            } else {
                self?.setSwipableAnimatingWithDelay()
            }
        })
    }
    
    private func setSwipableAnimatingWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: { [ weak self] in
            self?.isSwipableAnimating = false
        })
    }
    
    @objc func didTapBackgroundDim(_ recognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPresentationController
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        
        return CGRect(x: 0, y: 0, width: container.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView,
              let coordinator = presentingViewController.transitionCoordinator else { return }
        
        backgroundDimView.alpha = 0
        container.addSubview(backgroundDimView)
        backgroundDimView.addSubview(presentedViewController.view)
        
        NSLayoutConstraint.activate([
            presentedViewController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            presentedViewController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        coordinator.animate(alongsideTransition: { [ weak self ] _ in
            self?.backgroundDimView.alpha = 1
            self?.updateTopDistance()
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [ weak self ] _ -> Void in
            self?.backgroundDimView.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            backgroundDimView.removeFromSuperview()
        }
    }
}

extension HandyPresentationController: HandyScrollViewContentSizeDelegate {
    
    func registerHandyScrollView(_ scrollView: UIScrollView) {
        guard contentMode == .contentSize else { return }
        sheetType = .scrollView
        scrollView.layoutIfNeeded()
        
        contentSizeObserver = scrollView.observe(\.contentSize, options: .new) { [ weak self ] scrollView, _ in
            self?.handleScrollViewContentSizeChange(scrollView)
        }
        setScrollViewHeight(scrollView)
    }
    
    /// Manipulates stack view by adding empty arranged subview in the end,
    /// for those with types `UIStackView.Alignment.Distribution.fill` and `UIStackView.Alignment.Alignment.fill`
    /// - parameter stackView: `UIStackView` to be manipulated for height.
    func registerHandyStackView(_ stackView: UIStackView) {
        if stackView.alignment == .fill && stackView.distribution == .fill {
            sheetType = .stackView
            let emptyFooterView = UIView()
            emptyFooterView.backgroundColor = .clear
            stackView.addArrangedSubview(emptyFooterView)
        }
    }
    
}

extension HandyPresentationController {
    
    func handyScrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        guard !isSwipableAnimating && offset.y < 0 else { return }
        animatePanChange(translationY: -offset.y)
    }
    
    func handyScrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) {
        guard scrollView.contentOffset.y < 0 else { return }
        if scrollView.contentOffset.y < -130 {
            dismiss()
        } else {
            animatePanEnd(velocityCheck: velocity.y < -1.6)
        }
    }
    
    /// Changes scroll view height according to its content size.
    /// There is a workaround for issue where observed contentSize being called multiple times.
    private func handleScrollViewContentSizeChange(_ scrollView: UIScrollView) {
        guard temporaryScrollViewHeight == -1 else {
            temporaryScrollViewHeight = scrollView.contentSize.height
            return
        }
        temporaryScrollViewHeight = scrollView.contentSize.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [ weak self ] in
            guard let self = self else { return }
            self.setScrollViewHeight(scrollView)
        }
    }
    
    private func setScrollViewHeight(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = temporaryScrollViewHeight
        temporaryScrollViewHeight = -1
        scrollViewHeight = 0
        
        if UIScreen.main.bounds.height - contentHeight - scrollViewContentHeight < minimumTopDistance {
            scrollViewHeight = UIScreen.main.bounds.height - contentHeight - minimumTopDistance
        } else {
            scrollViewHeight = scrollViewContentHeight
        }
        
        if isKeyboardShown, keyboardHeight + minimumTopDistance * 2 > topDistance {
            scrollViewHeight -= keyboardHeight - topDistance + minimumTopDistance * 2
        }

        if scrollViewHeight == -1 {
            scrollViewHeight = 0
        }
        
        contentHeightConstraint?.constant = contentHeight + scrollViewHeight
        
        if scrollViewHeightConstraint == nil {
            scrollViewHeightConstraint = scrollView.heightAnchor.constraint(
                equalToConstant: scrollViewHeight
            )
            scrollViewHeightConstraint?.isActive = true
            updateTopDistance()
        } else {
            scrollViewHeightConstraint?.constant = scrollViewHeight
            self.topConstraint?.constant = self.topDistance - self.safeAreaInsets.bottom -
                self.safeAreaInsets.top
            animateDamping { [ weak self ] in
                self?.containerView?.layoutIfNeeded()
            }
        }
    }
    
    private func animateDamping(animations: @escaping (() -> Void)) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut, animations: animations)
    }
    
    private func updateSheetLocation(_ isKeyboardShown: Bool) {
        if isKeyboardShown, keyboardHeight + minimumTopDistance * 2 > topDistance {
            scrollViewHeight -= keyboardHeight - topDistance + minimumTopDistance * 2
        } else if
            !isKeyboardShown,
                UIScreen.main.bounds.height - keyboardHeight - scrollViewHeight - contentHeight == minimumTopDistance {
            switch sheetType {
            case .scrollView:
                scrollViewHeight = UIScreen.main.bounds.height - contentHeight - minimumTopDistance
            case .stackView:
                scrollViewHeight -= scrollViewHeight
            default:
                break
            }
        }
        safeAreaInsets.bottom += isKeyboardShown ? keyboardHeight : -keyboardHeight
        updateTopDistance()
        contentHeightConstraint?.constant = contentHeight + scrollViewHeight
        scrollViewHeightConstraint?.constant = scrollViewHeight
        topConstraint?.constant = topDistance - safeAreaInsets.bottom - safeAreaInsets.top
        animateDamping { [ weak self ] in
            self?.containerView?.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           !isKeyboardShown {
            isKeyboardShown = true
            keyboardHeight = keyboardFrame.cgRectValue.height
            updateSheetLocation(isKeyboardShown)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if isKeyboardShown, !presentedViewController.isBeingDismissed {
            isKeyboardShown = false
            updateSheetLocation(isKeyboardShown)
        }
    }
    
    @objc private func keyboardWillChange(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        isKeyboardShown, !presentedViewController.isBeingDismissed {
            let changedSize = keyboardFrame.cgRectValue.height - keyboardHeight
            keyboardHeight = keyboardFrame.cgRectValue.height
            safeAreaInsets.bottom += changedSize
            topConstraint?.constant -= changedSize
            animateDamping { [ weak self ] in
                self?.containerView?.layoutIfNeeded()
            }
        }
    }
}

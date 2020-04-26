//
//  ContentMode.swift
//  HandyViewController
//
//  Created by Rasid Ramazanov on 26.04.2020.
//

import Foundation

/// Content mode of the presented view controller with `HandyTransitioningDelegate`.
public enum ContentMode {
    /// View controller is displayed according to its content size.
    /// View hierarchy should be from top to bottom with constraints.
    /// Last component in the view hierarchy may have less priority to fix issues in IB.
    case contentSize
    /// View controller displayed full screen with a small padding in the top.
    case fullScreen
}

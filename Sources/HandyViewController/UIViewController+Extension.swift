//
//  UIViewController+Extension.swift
//  HandyViewController
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public var handyScrollViewDelegate: HandyScrollViewDelegate? {
        return (transitioningDelegate as? HandyTransitioningDelegate)?.scrollViewDelegate
    }
    
}

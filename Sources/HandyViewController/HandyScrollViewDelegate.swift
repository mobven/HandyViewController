//
//  HandyScrollViewDelegate.swift
//  HandyViewController
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

public protocol HandyScrollViewDelegate: class {
    func handyScrollViewDidSetContentSize(_ scrollView: UIScrollView)
    func handyScrollViewDidScroll(_ scrollView: UIScrollView)
    func handyScrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint)
}

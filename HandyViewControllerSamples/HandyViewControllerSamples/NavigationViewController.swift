//
//  NavigationViewController.swift
//  HandyViewControllerSamples
//
//  Created by Rasid Ramazanov on 02.05.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController {
    
    @IBAction func pushViewController() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "VeryShortHandyViewController")
        navigationController?.pushViewController(viewController!, animated: true)
    }
    
}

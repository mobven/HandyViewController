//
//  ViewController.swift
//  HandyViewControllerSamples
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit
import HandyViewController

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func presentHandyViewController() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "HandyViewController")
        let transitioningDelegate = HandyTransitioningDelegate(from: self, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction private func presentHandyTableViewController() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "HandyTableViewController")
        let transitioningDelegate = HandyTransitioningDelegate(from: self, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction private func presentVeryShortHandyViewController() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "VeryShortHandyViewController")
        let transitioningDelegate = HandyTransitioningDelegate(from: self, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction private func presentNavigationController() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController")
        let transitioningDelegate = HandyTransitioningDelegate(from: self, to: controller, contentMode: .fullScreen)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
}

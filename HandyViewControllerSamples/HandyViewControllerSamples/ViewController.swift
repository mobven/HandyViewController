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
    
    private var detailsTransitioningDelegate: HandyTransitioningDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func presentHandyViewController() {
        let controller = UIStoryboard(
            name: "Main", bundle: nil
        ).instantiateViewController(withIdentifier: "HandyViewController")
        detailsTransitioningDelegate = HandyTransitioningDelegate(from: self, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction private func presentHandyTableViewController() {
        let controller = UIStoryboard(
            name: "Main", bundle: nil
        ).instantiateViewController(withIdentifier: "HandyTableViewController")
        detailsTransitioningDelegate = HandyTransitioningDelegate(from: self, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction private func presentVeryShortHandyViewController() {
        let controller = UIStoryboard(
            name: "Main", bundle: nil
        ).instantiateViewController(withIdentifier: "VeryShortHandyViewController")
        detailsTransitioningDelegate = HandyTransitioningDelegate(from: self, to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
}

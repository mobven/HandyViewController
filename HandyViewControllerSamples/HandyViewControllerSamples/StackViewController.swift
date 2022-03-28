//
//  StackViewController.swift
//  HandyViewControllerSamples
//
//  Created by Rasid Ramazanov on 08.05.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var someField: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerHandyStackView(stackView)
    }
    
}

extension StackViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(false)
    }
}

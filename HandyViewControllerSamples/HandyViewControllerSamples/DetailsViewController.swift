//
//  COntrollers.swift
//  HandyViewControllerSamples
//
//  Created by Rasid Ramazanov on 19.04.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit
import HandyViewController

final class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerHandyScrollView(tableView)
        for index in 1...21 {
            data.append("Cell no: \(index)")
        }
    }
    
    @IBAction func addMoreItems() {
        for index in 1...3 {
            data.append("Cell no: \(index)")
        }
        tableView.reloadData()
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = data[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension DetailsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handyScrollViewDelegate?.handyScrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        handyScrollViewDelegate?.handyScrollViewWillEndDragging(scrollView, withVelocity: velocity)
    }
    
}

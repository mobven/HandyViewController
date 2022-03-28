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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data: [String] = []
    var searchedData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerHandyScrollView(tableView)
        for index in 1...5 {
            data.append("Cell no: \(index)")
        }
        searchedData = data
    }
    
    @IBAction func addMoreItems() {
        for index in data.count...data.count+3 {
            data.append("Cell no: \(index)")
        }
        searchedData = data
        tableView.reloadData()
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = searchedData[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension DetailsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchedData = data
            tableView.reloadData()
            return
        }
        searchedData = data.filter {
            $0.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension DetailsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handyScrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        handyScrollViewWillEndDragging(scrollView, withVelocity: velocity)
    }
}

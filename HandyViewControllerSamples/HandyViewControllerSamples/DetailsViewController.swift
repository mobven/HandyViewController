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
    
    let pickerView = UIPickerView()
    var data: [String] = []
    var searchedData: [String] = []
    var keyboard: KeyboardType = .standart
    
    enum KeyboardType: CaseIterable {
        case standart, numberPad, pickerView
        
        mutating func next() {
            let allCases = type(of: self).allCases
            self = allCases[(allCases.firstIndex(of: self)! + 1) % allCases.count]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
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
    
    @IBAction func changeKeyboard() {
        let textField = UITextField(frame: .zero)
        textField.resignFirstResponder()
        switch keyboard {
        case .standart:
            textField.inputView = .none
            textField.keyboardType = .default
        case .numberPad:
            textField.inputView = .none
            textField.keyboardType = .numberPad
        case .pickerView:
            textField.inputView = pickerView
        }
        view.addSubview(textField)
        textField.becomeFirstResponder()
        keyboard.next()
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

extension DetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchedData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return searchedData[row]
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

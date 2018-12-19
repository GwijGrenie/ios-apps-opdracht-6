//
//  UITableViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func reloadRow(at indexpath: IndexPath, with animation: UITableView.RowAnimation) {
        var tempWrapper: [IndexPath] = [IndexPath]()
        tempWrapper.append(indexpath)
        self.reloadRows(at: tempWrapper, with: animation)
    }
}

//
//  PullToRefreshable.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 14.01.2024.
//

import UIKit

class PullToRefreshComponent {
    var refreshControl: UIRefreshControl
    
    init() {
        self.refreshControl = UIRefreshControl()
    }
    
    func setup(with tableView: UITableView, target: AnyObject, action: Selector) {
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

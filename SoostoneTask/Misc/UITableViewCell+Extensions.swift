//
//  UITableViewCell+Extensions.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import UIKit

// Extension for UITableViewCell to enhance its functionality.
extension UITableViewCell {
    
    // Static computed property to get a unique identifier for the UITableViewCell.
    // This identifier is typically used for cell reuse purposes in a UITableView.
    // - Returns: A string representing the class name of the cell, which acts as a unique identifier.
    static var identifier: String {
        // Uses the name of the class itself as the identifier.
        return String(describing: self)
    }
}

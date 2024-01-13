//
//  UITableViewController+Extensions.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import UIKit

// Extension to UITableView for added convenience in cell registration and handling empty states.
extension UITableView {
    
    // Registers a UITableViewCell using its class type.
    // This method simplifies the process of registering cells for the table view.
    // - Parameter type: The UITableViewCell type to be registered.
    func register<T: UITableViewCell>(type: T.Type) {
        // Obtain a string representation of the cell's type, typically the class name.
        let className = String(describing: type.self)
        // Create a UINib object from the class name, assuming the nib file has the same name as the class.
        let nib = UINib(nibName: className, bundle: nil)
        // Register the nib with the table view.
        self.register(nib, forCellReuseIdentifier: className)
    }
    
    // Sets an empty message with a specific font when the table view has no data to display.
    // - Parameters:
    //   - message: The message to display in the empty table view.
    //   - font: The font used for the message.
    func setEmptyMessage(_ message: String, font: UIFont) {
        // Create a UILabel with a frame matching the table view's size.
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.center = self.center // Center the label in the table view.
        messageLabel.text = message // Set the provided message.
        messageLabel.textColor = UIColor(red: 0.424, green: 0.424, blue: 0.49, alpha: 1) // Set the text color.
        messageLabel.numberOfLines = 0 // Allow multiple lines.
        messageLabel.textAlignment = .center // Center-align the text.
        messageLabel.font = font // Set the provided font.
        messageLabel.sizeToFit() // Adjust the label size to fit the content.

        // Set the label as the background view of the table view and remove separators.
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    // Restores the table view to its default state by removing the background view and showing separators.
    func restore() {
        self.backgroundView = nil // Remove the background view.
        self.separatorStyle = .singleLine // Restore the separator style to single line.
    }
}


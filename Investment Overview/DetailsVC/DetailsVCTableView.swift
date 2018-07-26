//
//  DetailsVCTableView.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 26.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation
import Cocoa


extension DetailsVC: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        // Return the count of any array of selectedInvestment - if it is nil return 0
        return selectedInvestment?.date?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "dateCell"), owner: self) as? NSTableCellView
        
        if tableColumn?.identifier.rawValue == "dateColumn" {
            // get date from date picker or if that is ill-defined get current date
            let date = selectedInvestment?.date?[row] ?? Date()
            let formatter = DateFormatter()
            // This is to get a nice format for the date
            guard let style = DateFormatter.Style(rawValue: 2) else {
                print("The style did not work")
                return cell
            }
            formatter.dateStyle = style
            let dateString = formatter.string(from: date)
            cell?.textField?.stringValue = dateString
        }
        
        if tableColumn?.identifier.rawValue == "exchangeColumn" {
            let exchange = selectedInvestment?.exchange?[row] ?? ""
            cell?.textField?.stringValue = exchange
        }
        
        if tableColumn?.identifier.rawValue == "typeColumn" {
            let type = selectedInvestment?.type?[row] ?? "Type is nil"
            cell?.textField?.stringValue = type
        }
        
        if tableColumn?.identifier.rawValue == "amountColumn" {
            let units = selectedInvestment?.unitsBought?[row] ?? 0.0
            cell?.textField?.stringValue = "\(units)"
        }
        
        if tableColumn?.identifier.rawValue == "priceColumn" {
            let price = selectedInvestment?.priceEUR?[row] ?? 0.0
            cell?.textField?.stringValue = "\(price) €"
        }
        
        if tableColumn?.identifier.rawValue == "investedMoneyColumn" {
            let price = selectedInvestment?.priceEUR?[row] ?? 0.0
            let units = selectedInvestment?.unitsBought?[row] ?? 0.0
            // Display the rounded value to two digits as a string
            cell?.textField?.stringValue = String(format: "%.2f €", price*units)
        }
        
        if tableColumn?.identifier.rawValue == "feesColumn" {
            let fees = selectedInvestment?.fees?[row] ?? 0.0
            cell?.textField?.stringValue = String(format: "%.2f €", fees)
        }
        
        if tableColumn?.identifier.rawValue == "profitColumn" {
            let profit = 0.0
            cell?.textField?.doubleValue = profit
        }
        
        return cell
    }
}


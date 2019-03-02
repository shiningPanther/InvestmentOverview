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
        return selectedTransactions?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "dateCell"), owner: self) as? NSTableCellView
        cell?.textField?.font = NSFont .systemFont(ofSize: 12)
        
        if tableColumn?.identifier.rawValue == "dateColumn" {
            let date = selectedTransactions?[row].date ?? Date()
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
            let exchange = selectedTransactions?[row].exchange ?? ""
            cell?.textField?.stringValue = exchange
        }
        
        if tableColumn?.identifier.rawValue == "typeColumn" {
            let type = selectedTransactions?[row].type ?? "Type is nil"
            cell?.textField?.stringValue = type
        }
        
        if tableColumn?.identifier.rawValue == "amountColumn" {
            let units = selectedTransactions?[row].unitsBought ?? 0.0
            cell?.textField?.stringValue = "\(units)"
            if selectedTransactions?[row].type == "Dividends" {
                cell?.textField?.stringValue = "-"
            }
        }
        
        if tableColumn?.identifier.rawValue == "priceColumn" {
            let price = selectedTransactions?[row].price ?? 0.0
            cell?.textField?.stringValue = String(format: "%.2f €", price)
            // Return nothing in this column if it is an airdrop
            if selectedTransactions?[row].type == "Airdrop" || selectedTransactions?[row].type == "Dividends" {
                cell?.textField?.stringValue = "-"
            }
        }
        
        if tableColumn?.identifier.rawValue == "investedMoneyColumn" {
            let price = selectedTransactions?[row].price ?? 0.0
            let units = selectedTransactions?[row].unitsBought ?? 0.0
            // Display the rounded value to two digits as a string
            cell?.textField?.stringValue = String(format: "%.2f €", price*units)
            // Return nothing in this column if it is an airdrop
            if selectedTransactions?[row].type == "Airdrop" || selectedTransactions?[row].type == "Dividends" {
                cell?.textField?.stringValue = "-"
            }
        }
        
        if tableColumn?.identifier.rawValue == "feesColumn" {
            let fees = selectedTransactions?[row].fees ?? 0.0
            cell?.textField?.stringValue = String(format: "%.2f €", fees)
            // Return nothing in this column if it is an airdrop
            if selectedTransactions?[row].type == "Airdrop" || selectedTransactions?[row].type == "Dividends" {
                cell?.textField?.stringValue = "-"
            }
        }
        
        if tableColumn?.identifier.rawValue == "profitColumn" {
            let profit = selectedTransactions?[row].profit ?? 0.0
            if profit == 0 {
                cell?.textField?.stringValue = "-"
            }
            else {
                cell?.textField?.stringValue = String(format: "%.2f €", profit)
            }
            
            if profit < 0 {
                cell?.textField?.textColor = NSColor.red
            }
            else {cell?.textField?.textColor = NSColor.black}
        }
        
        return cell
    }
}


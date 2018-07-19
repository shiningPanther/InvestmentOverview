//
//  DetailsVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 15.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

class DetailsVC: NSViewController {
    
    var overviewVC: OverviewVC?
    var selectedInvestment: Transaction2?
    var selectedCategory: String?
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var totalInvestedMoneyAmount: NSTextField!
    @IBOutlet weak var totalRealizedProfitsAmount: NSTextField!
    @IBOutlet weak var totalUnrealizedProfitsAmount: NSTextField!
    @IBOutlet weak var totalTotalProfitsAmount: NSTextField!
    @IBOutlet weak var categoryLabel: NSTextField!
    @IBOutlet weak var categoryInvestedMoneyLabel: NSTextField!
    @IBOutlet weak var categoryRealizedProfitsLabel: NSTextField!
    @IBOutlet weak var categoryUnrealizedProfitsLabel: NSTextField!
    @IBOutlet weak var categoryTotalProfitsLabel: NSTextField!
    @IBOutlet weak var categoryInvestedMoneyAmount: NSTextField!
    @IBOutlet weak var categoryRealizedProfitsAmount: NSTextField!
    @IBOutlet weak var categoryUnrealizedProfitsAmount: NSTextField!
    @IBOutlet weak var categoryTotalProfitsAmount: NSTextField!
    @IBOutlet weak var investmentLabel: NSTextField!
    @IBOutlet weak var investmentInvestedMoneyLabel: NSTextField!
    @IBOutlet weak var investmentRealizedProfitsLabel: NSTextField!
    @IBOutlet weak var investmentUnrealizedProfitsLabel: NSTextField!
    @IBOutlet weak var investmentTotalProfitsLabel: NSTextField!
    @IBOutlet weak var investmentInvestedMoneyAmount: NSTextField!
    @IBOutlet weak var investmentRealizedProfitsAmount: NSTextField!
    @IBOutlet weak var investmentUnrealizedProfitsAmount: NSTextField!
    @IBOutlet weak var investmentTotalProfitsAmount: NSTextField!
    @IBOutlet weak var detailsScrollView: NSScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide everything at the beginning
        hideInvestment()
        hideCategory()
    }
    
    func updateView() {
        // nothing in the overviewVC outline view is selected
        if selectedInvestment == nil && selectedCategory == nil {
            hideInvestment()
            hideCategory()
        }
        
        // now check if a category or investment is selected
        if selectedCategory != nil {
            unhideCategory()
            hideInvestment()
            categoryLabel.stringValue = "Category: \(selectedCategory!)"
        } else if selectedInvestment != nil {
            unhideCategory()
            unhideInvestment()
            categoryLabel.stringValue = "Category: \(selectedInvestment!.categoryName!)"
            investmentLabel.stringValue = "\(selectedInvestment!.investmentName!)"
            tableView.reloadData()
        } else {
            hideCategory()
            hideInvestment()
        }
    }
    
    
    
    func hideInvestment() {
        investmentLabel.isHidden = true
        investmentInvestedMoneyLabel.isHidden = true
        investmentRealizedProfitsLabel.isHidden = true
        investmentUnrealizedProfitsLabel.isHidden = true
        investmentInvestedMoneyAmount.isHidden = true
        investmentTotalProfitsLabel.isHidden = true
        investmentRealizedProfitsAmount.isHidden = true
        investmentUnrealizedProfitsAmount.isHidden = true
        investmentTotalProfitsAmount.isHidden = true
        detailsScrollView.isHidden = true
    }
    
    func unhideInvestment() {
        investmentLabel.isHidden = false
        investmentInvestedMoneyLabel.isHidden = false
        investmentRealizedProfitsLabel.isHidden = false
        investmentUnrealizedProfitsLabel.isHidden = false
        investmentTotalProfitsLabel.isHidden = false
        investmentInvestedMoneyAmount.isHidden = false
        investmentRealizedProfitsAmount.isHidden = false
        investmentUnrealizedProfitsAmount.isHidden = false
        investmentTotalProfitsAmount.isHidden = false
        detailsScrollView.isHidden = false
    }
    
    func hideCategory() {
        categoryLabel.isHidden = true
        categoryInvestedMoneyLabel.isHidden = true
        categoryRealizedProfitsLabel.isHidden = true
        categoryUnrealizedProfitsLabel.isHidden = true
        categoryTotalProfitsLabel.isHidden = true
        categoryInvestedMoneyAmount.isHidden = true
        categoryRealizedProfitsAmount.isHidden = true
        categoryUnrealizedProfitsAmount.isHidden = true
        categoryTotalProfitsAmount.isHidden = true
    }
    
    func unhideCategory() {
        categoryLabel.isHidden = false
        categoryInvestedMoneyLabel.isHidden = false
        categoryRealizedProfitsLabel.isHidden = false
        categoryUnrealizedProfitsLabel.isHidden = false
        categoryTotalProfitsLabel.isHidden = false
        categoryInvestedMoneyAmount.isHidden = false
        categoryRealizedProfitsAmount.isHidden = false
        categoryUnrealizedProfitsAmount.isHidden = false
        categoryTotalProfitsAmount.isHidden = false
    }
    
}



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
            let type = "Buy/Sell"
            cell?.textField?.stringValue = type
        }
        
        if tableColumn?.identifier.rawValue == "amountColumn" {
            let units = selectedInvestment?.unitsBought?[row] ?? 0.0
            cell?.textField?.doubleValue = units
        }
        
        if tableColumn?.identifier.rawValue == "priceColumn" {
            let price = selectedInvestment?.priceEUR?[row] ?? 0.0
            cell?.textField?.doubleValue = price
        }
        
        if tableColumn?.identifier.rawValue == "investedMoneyColumn" {
            let price = selectedInvestment?.priceEUR?[row] ?? 0.0
            let units = selectedInvestment?.unitsBought?[row] ?? 0.0
            cell?.textField?.doubleValue = price*units
        }
        
        if tableColumn?.identifier.rawValue == "profitColumn" {
            let profit = 0.0
            cell?.textField?.doubleValue = profit
        }
        
        return cell
    }
}

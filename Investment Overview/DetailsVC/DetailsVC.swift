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
    @IBOutlet weak var balanceLabel: NSTextField!
    @IBOutlet weak var currentPriceLabel: NSTextField!
    @IBOutlet weak var lastUpdateLabel: NSTextField!
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
        print("detailsVC update view is now running")
        print("Selected category: \(selectedCategory)")
        print("Selected investment: \(selectedInvestment)")
        // test to see if we can get the ETH price
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=EUR") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else{
                    print("An error occured")
                    print(error!)
                    return
                }
                guard data != nil else {return}
                // Make a json object out of the returned data
                let json = JSON(data!)
                print(json["EUR"].double ?? "Not defined")
            }.resume()
        }
        
        // nothing in the overviewVC outline view is selected
        if selectedInvestment == nil && selectedCategory == nil {
            hideInvestment()
            hideCategory()
        }
        
        // now check if a category or investment is selected
        if selectedCategory != nil {
            unhideCategory()
            hideInvestment()
            updateCategory(category: selectedCategory!)
        } else if selectedInvestment != nil {
            unhideCategory()
            unhideInvestment()
            updateInvestment(investment: selectedInvestment!)
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        switch tableView.selectedRow {
        case -1:
            overviewVC?.editButton.isEnabled = false
            overviewVC?.deleteButton.isEnabled = false
        default:
            // Also make sure that something is selected in the overviewVC...
            guard overviewVC?.outlineView.selectedRow != nil else {return}
            guard (overviewVC?.outlineView.selectedRow)! >= 0 else {return}
            overviewVC?.editButton.isEnabled = true
            overviewVC?.deleteButton.isEnabled = true
        }
    }
}

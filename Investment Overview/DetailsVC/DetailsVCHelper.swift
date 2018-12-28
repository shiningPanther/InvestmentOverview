//
//  DetailsVCHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 26.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation


extension DetailsVC {
    
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
            updateCategory(category: selectedCategory!)
        } else if selectedInvestment != nil {
            unhideCategory()
            unhideInvestment()
            updateInvestment(investment: selectedInvestment!)
        }
    }
    
    func updateCategory(category: Category) {
        categoryLabel.stringValue = "Category: \(category.name ?? "No category selected - This should never happen...")"
    }
    
    func updateInvestment(investment: Investment) {
        guard let category = investment.category else {return}
        updateCategory(category: category)
        
        investmentLabel.stringValue = String(format: "%@:", investment.name ?? "")
        balanceLabel.stringValue = String(format: "%.4f %@", investment.balance, investment.symbol ?? "")
        currentPriceLabel.stringValue = String(format: "Current price: %.4f €", investment.currentPrice)
        
        // This is for the date label
        let date = investment.lastUpdate ?? Date()
        let formatter = DateFormatter()
        // This is to get a nice format for the date
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: date)
        lastUpdateLabel.stringValue = String(format: "Last update: %@", dateString)
        
        investmentInvestedMoneyAmount.stringValue = String(format: "%.2f €", investment.balance * investment.currentPrice)
        investmentRealizedProfitsAmount.stringValue = String(format: "%.2f €", investment.realizedProfits)
        investmentUnrealizedProfitsAmount.stringValue = String(format: "%.2f €", investment.unrealizedProfits)
        
        tableView.reloadData()
    }
    
    func hideInvestment() {
        investmentLabel.isHidden = true
        balanceLabel.isHidden = true
        currentPriceLabel.isHidden = true
        lastUpdateLabel.isHidden = true
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
        balanceLabel.isHidden = false
        currentPriceLabel.isHidden = false
        lastUpdateLabel.isHidden = false
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

//
//  DetailsVCHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 26.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation
import Cocoa


extension DetailsVC {
    
    func updateView() {
        
        // nothing in the overviewVC outline view is selected
        if selectedInvestment == nil && selectedCategory == nil {
            hideInvestment()
            hideCategory()
            updateTotal()
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
    
    func updateTotal() {
        let (investedMoney, currentValueOfAssets, realizedProfits, unrealizedProfits) = SortAndCalculate.calculateTotalProfits()
        totalInvestedMoney.stringValue = String(format: "%.2f €", investedMoney)
        totalCurrentValueOfAssets.stringValue = String(format: "%.2f €", currentValueOfAssets)
        totalRealizedProfitsAmount.stringValue = String(format: "%.2f €", realizedProfits)
        if realizedProfits < 0 {totalRealizedProfitsAmount.textColor = NSColor.red}
        else {totalRealizedProfitsAmount.textColor = NSColor.black}
        totalUnrealizedProfitsAmount.stringValue = String(format: "%.2f €", unrealizedProfits)
        if unrealizedProfits < 0 {totalUnrealizedProfitsAmount.textColor = NSColor.red}
        else {totalUnrealizedProfitsAmount.textColor = NSColor.black}
        totalTotalProfitsAmount.stringValue = String(format: "%.2f €", realizedProfits + unrealizedProfits)
        if realizedProfits + unrealizedProfits < 0 {totalTotalProfitsAmount.textColor = NSColor.red}
        else {totalTotalProfitsAmount.textColor = NSColor.black}
    }
    
    func updateCategory(category: Category) {
        categoryLabel.stringValue = "Category: \(category.name ?? "No category selected - This should never happen...")"
        categoryInvestedMoneyAmount.stringValue = String(format: "%.2f €", category.investedMoney)
        categoryCurrentValueOfAssetsAmount.stringValue = String(format: "%.2f €", category.currentValueOfAssets)
        categoryRealizedProfitsAmount.stringValue = String(format: "%.2f €", category.realizedProfits)
        if category.realizedProfits < 0 {categoryRealizedProfitsAmount.textColor = NSColor.red}
        else {categoryRealizedProfitsAmount.textColor = NSColor.black}
        categoryUnrealizedProfitsAmount.stringValue = String(format: "%.2f €", category.unrealizedProfits)
        if category.unrealizedProfits < 0 {categoryUnrealizedProfitsAmount.textColor = NSColor.red}
        else {categoryUnrealizedProfitsAmount.textColor = NSColor.black}
        categoryTotalProfitsAmount.stringValue = String(format: "%.2f €", category.realizedProfits + category.unrealizedProfits)
        if category.realizedProfits + category.unrealizedProfits < 0 {categoryTotalProfitsAmount.textColor = NSColor.red}
        else {categoryTotalProfitsAmount.textColor = NSColor.black}
        
        updateTotal()
    }
    
    func updateInvestment(investment: Investment) {
        
        investmentLabel.stringValue = String(format: "%@:", investment.name ?? "")
        if investment.apiWebsite == "CryptoCompare" {
            balanceLabel.stringValue = String(format: "%.4f %@", investment.balance, investment.symbol ?? "")
        }
        else {
            balanceLabel.stringValue = String(format: "%.0f %@", investment.balance, investment.symbol ?? "")
        }
        if investment.apiWebsite == "CryptoCompare" {
            currentPriceLabel.stringValue = String(format: "Current price: %.4f €", investment.currentPrice)
        }
        else {
            currentPriceLabel.stringValue = String(format: "Current price: %.2f €", investment.currentPrice)
        }
        if investment.currentPrice == 0.0 { currentPriceLabel.stringValue = "Current Price: N/A"}
        
        // This is for the date label
        let date = investment.lastUpdate ?? Date(timeIntervalSince1970: 0)
        let formatter = DateFormatter()
        // This is to get a nice format for the date
        formatter.dateStyle = .short
//        formatter.timeStyle = .medium
        let dateString = formatter.string(from: date)
        lastUpdateLabel.stringValue = String(format: "Last update: %@", dateString)
        
        investmentInvestedMoneyAmount.stringValue = String(format: "%.2f €", investment.investedMoney)
        investmentCurrentValueOfAssetsAmount.stringValue = String(format: "%.2f €", investment.currentValueOfAssets)
        investmentRealizedProfitsAmount.stringValue = String(format: "%.2f €", investment.realizedProfits)
        if investment.realizedProfits < 0 {investmentRealizedProfitsAmount.textColor = NSColor.red}
        else {investmentRealizedProfitsAmount.textColor = NSColor.black}
        investmentUnrealizedProfitsAmount.stringValue = String(format: "%.2f €", investment.unrealizedProfits)
        if investment.unrealizedProfits < 0 {investmentUnrealizedProfitsAmount.textColor = NSColor.red}
        else {investmentUnrealizedProfitsAmount.textColor = NSColor.black}
        investmentTotalProfitsAmount.stringValue = String(format: "%.2f €", investment.totalProfits)
        if investment.totalProfits < 0 {investmentTotalProfitsAmount.textColor = NSColor.red}
        else {investmentTotalProfitsAmount.textColor = NSColor.black}

        tableView.reloadData()
        
        guard let category = investment.category else {return}
        updateCategory(category: category)
    }
    
    func hideInvestment() {
        investmentLabel.isHidden = true
        balanceLabel.isHidden = true
        currentPriceLabel.isHidden = true
        lastUpdateLabel.isHidden = true
        investmentInvestedMoneyLabel.isHidden = true
        investmentCurrentValueOfAssetsLabel.isHidden = true
        investmentRealizedProfitsLabel.isHidden = true
        investmentUnrealizedProfitsLabel.isHidden = true
        investmentInvestedMoneyAmount.isHidden = true
        investmentCurrentValueOfAssetsAmount.isHidden = true
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
        investmentCurrentValueOfAssetsLabel.isHidden = false
        investmentRealizedProfitsLabel.isHidden = false
        investmentUnrealizedProfitsLabel.isHidden = false
        investmentTotalProfitsLabel.isHidden = false
        investmentInvestedMoneyAmount.isHidden = false
        investmentCurrentValueOfAssetsAmount.isHidden = false
        investmentRealizedProfitsAmount.isHidden = false
        investmentUnrealizedProfitsAmount.isHidden = false
        investmentTotalProfitsAmount.isHidden = false
        detailsScrollView.isHidden = false
    }
    
    func hideCategory() {
        categoryLabel.isHidden = true
        categoryInvestedMoneyLabel.isHidden = true
        categoryCurrentValueOfAssetsLabel.isHidden = true
        categoryRealizedProfitsLabel.isHidden = true
        categoryUnrealizedProfitsLabel.isHidden = true
        categoryTotalProfitsLabel.isHidden = true
        categoryInvestedMoneyAmount.isHidden = true
        categoryCurrentValueOfAssetsAmount.isHidden = true
        categoryRealizedProfitsAmount.isHidden = true
        categoryUnrealizedProfitsAmount.isHidden = true
        categoryTotalProfitsAmount.isHidden = true
    }
    
    func unhideCategory() {
        categoryLabel.isHidden = false
        categoryInvestedMoneyLabel.isHidden = false
        categoryCurrentValueOfAssetsLabel.isHidden = false
        categoryRealizedProfitsLabel.isHidden = false
        categoryUnrealizedProfitsLabel.isHidden = false
        categoryTotalProfitsLabel.isHidden = false
        categoryInvestedMoneyAmount.isHidden = false
        categoryCurrentValueOfAssetsAmount.isHidden = false
        categoryRealizedProfitsAmount.isHidden = false
        categoryUnrealizedProfitsAmount.isHidden = false
        categoryTotalProfitsAmount.isHidden = false
    }
    
}

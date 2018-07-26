//
//  DetailsVCHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 26.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation


extension DetailsVC {
    
    func updateCategory(category: String) {
        categoryLabel.stringValue = "Category: \(selectedCategory!)"
    }
    
    func updateInvestment(investment: Transaction2) {
        categoryLabel.stringValue = "Category: \(selectedInvestment!.categoryName ?? "No category selected")"
        investmentLabel.stringValue = "\(selectedInvestment!.investmentName ?? "No investment selected")"
        balanceLabel.stringValue = String(selectedInvestment!.currentBalance)
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

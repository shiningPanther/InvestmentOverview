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
        // test to see if we can get the ETH price
        print("This is done in the updateView function of DetailsVC")
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
    
    func updateCategory(category: Category) {
        categoryLabel.stringValue = "Category: \(category.name!)"
    }
    
    func updateInvestment(investment: Investment) {
        categoryLabel.stringValue = "Category: \(investment.category?.name ?? "No category selected - This should never happen...")"
        investmentLabel.stringValue = "\(investment.name ?? "No investment selected - This should never happen...")"
        balanceLabel.stringValue = String(investment.balance)
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

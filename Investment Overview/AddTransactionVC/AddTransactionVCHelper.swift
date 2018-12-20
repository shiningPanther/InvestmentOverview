//
//  AddTransactionVCHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 21.08.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa


extension AddTransactionVC {
    
    func updateView() {
        // Populate the investmentCategory pop up button
        investmentCategoryPopUpButton.addItems(withTitles: getCategoryNames())
        investmentCategoryPopUpButton.selectItem(at: -1)
        
        // Show an item in the investment category pop up button if either an investment or category are selected
        if selectedCategory != nil {
            investmentCategoryPopUpButton.selectItem(withTitle: selectedCategory?.name ?? "")
        }
        if selectedInvestment != nil {
            investmentCategoryPopUpButton.selectItem(withTitle: selectedInvestment?.category?.name ?? "")
            populateInvestmentPopUpButton()
            investmentNamePopUpButton.selectItem(withTitle: selectedInvestment?.name ?? "")
            updateTextFieldsForInvestment(investment: selectedInvestment)
        }
        // Set the date to the current date
        datePicker.dateValue = Date()
    }
    
    func populateInvestmentPopUpButton() {
        if let category = investmentCategoryPopUpButton.titleOfSelectedItem {
            investmentNamePopUpButton.addItems(withTitles: getInvestmentNames(categoryName: category))
        }
    }
    
    func updateTextFieldsForInvestment(investment: Investment?) {
        guard investment != nil else {return}
        if let symbol = investment?.symbol {
            symbolTextField.stringValue = symbol
        }
        if let isin = investment?.isin {
            isinTextField.stringValue = isin
        }
        if let api = investment?.apiWebsite {
            // This still needs to be changed: We want to have here all the possible apis where to get real time data...
            apiPopUpButton.addItem(withTitle: api)
            apiPopUpButton.selectItem(withTitle: api)
        }
    }
    
    func removeAllInvestmentFields() {
        symbolTextField.stringValue = ""
        isinTextField.stringValue = ""
        apiPopUpButton.selectItem(at: -1)
    }
    
    // returns an array from the categories containing their names
    func getCategoryNames() -> [String] {
        var categoryNames: [String] = []
        for category in CoreDataHelper.categories {
            if category.name != nil { categoryNames.append(category.name!) }
        }
        return categoryNames
    }
    
    // returns an array of the investment names belonging to a specific category
    func getInvestmentNames(categoryName: String) -> [String] {
        let investments = CoreDataHelper.investments.filter({$0.category?.name == categoryName})
        var investmentNames: [String] = []
        for investment in investments {
            if investment.name != nil { investmentNames.append(investment.name!) }
        }
        return investmentNames
    }
    
}
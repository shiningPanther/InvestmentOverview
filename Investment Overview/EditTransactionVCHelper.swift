//
//  EditTransactionVCHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 28.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation
import Cocoa


extension EditTransactionVC {
    
    func updateView() {
        // first make sure that both an investment and transaction are selected
        guard selectedInvestment != nil else {return}
        guard selectedTransaction != nil else {return}
        updateInvestmentFields(investment: selectedInvestment!)
        updateTransactionFields(investment: selectedInvestment!, row: selectedTransaction!)
    }
    
    func updateInvestmentFields(investment: Transaction2) {
        investmentNameTextField.stringValue = investment.investmentName ?? ""
        categoryNameTextField.stringValue = investment.categoryName ?? ""
        symbolTextField.stringValue = investment.investmentSymbol ?? ""
        //isinTextField.stringValue = investment.investmentISIN ?? ""
        apiPopUpButton.addItems(withTitles: ViewHelper.apiNames)
        apiPopUpButton.selectItem(withTitle: investment.apiWebsite ?? "")
    }
    
    func updateTransactionFields(investment: Transaction2, row: Int) {
        transactionTypePopUpButton.addItems(withTitles: ViewHelper.transactionTypes)
        transactionTypePopUpButton.selectItem(withTitle: investment.type?[row] ?? "")
        datePicker.dateValue = investment.date?[row] ?? Date()
        exchangeNameTextField.stringValue = investment.exchange?[row] ?? ""
        exchangeNameTextField.stringValue = investment.exchange?[row] ?? ""
        unitsBoughtTextField.stringValue = investment.unitsBought?[row].description ?? ""
        priceTextField.stringValue = investment.priceEUR?[row].description ?? ""
        feesTextField.stringValue = investment.fees?[row].description ?? ""
    }
    
}

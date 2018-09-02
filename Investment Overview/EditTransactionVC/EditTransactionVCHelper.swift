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
        updateCategoryFields()
        updateInvestmentFields()
        updateTransactionFields()
    }
    
    // update all the fields that are related to a category
    func updateCategoryFields() {
        categoryNameTextField.stringValue = selectedInvestment?.name ?? ""
    }
    
    // update all the fields that are related to an investment
    func updateInvestmentFields() {
        investmentNameTextField.stringValue = selectedInvestment?.name ?? ""
        symbolTextField.stringValue = selectedInvestment?.symbol ?? ""
        //isinTextField.stringValue = selectedInvestment?.isin ?? ""
        apiPopUpButton.addItems(withTitles: ViewHelper.apiNames)
        apiPopUpButton.selectItem(withTitle: selectedInvestment?.apiWebsite ?? "")
    }
    
    // update all the fields that are related to a transaction
    func updateTransactionFields() {
        transactionTypePopUpButton.addItems(withTitles: ViewHelper.transactionTypes)
        transactionTypePopUpButton.selectItem(withTitle: selectedTransaction?.type ?? "")
        datePicker.dateValue = selectedTransaction?.date ?? Date()
        exchangeNameTextField.stringValue = selectedTransaction?.exchange ?? ""
        unitsBoughtTextField.doubleValue = selectedTransaction?.unitsBought ?? 0.0
        priceTextField.doubleValue = selectedTransaction?.price ?? 0.0
        feesTextField.doubleValue = selectedTransaction?.fees ?? 0.0
    }
    
}

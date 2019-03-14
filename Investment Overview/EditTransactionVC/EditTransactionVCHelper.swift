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
        categoryNameTextField.stringValue = selectedInvestment?.category?.name ?? ""
    }
    
    // update all the fields that are related to an investment
    func updateInvestmentFields() {
        investmentNameTextField.stringValue = selectedInvestment?.name ?? ""
        symbolTextField.stringValue = selectedInvestment?.symbol ?? ""
        isinTextField.stringValue = selectedInvestment?.isin ?? ""
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
    
    // update all the transaction properties with the text fields
    func updateTransaction() {
        // For predicates look up this site
        // https://code.tutsplus.com/tutorials/core-data-and-swift-relationships-and-more-fetching--cms-25070
        selectedTransaction?.unitsBought = unitsBoughtTextField.doubleValue
        selectedTransaction?.price = priceTextField.doubleValue
        selectedTransaction?.fees = feesTextField.doubleValue
        selectedTransaction?.exchange = exchangeNameTextField.stringValue
        selectedTransaction?.date = datePicker.dateValue
        selectedTransaction?.type = transactionTypePopUpButton.titleOfSelectedItem
    }
    
    // Check that the category name is not the name of any investment (including a possible renaming)
    func newCategoryNameIsValid(newCategoryName: String) -> Bool {
        // Make sure that the new category name is not the name of an existing investment already
        guard !CoreDataHelper.investments.contains(where: {$0.name == newCategoryName}) else {return false}
        // Make sure that the new category name is not the name of the new investment
        guard newCategoryName != investmentNameTextField.stringValue else {return false}
        return true
    }
    
    // Change the category name that an investment belongs to
    func updateCategory(categoryName: String) {
        let category = CoreDataHelper.categories.filter{$0.name == categoryName}
        guard category.count == 1 else {return}
        selectedInvestment?.category = category[0]
    }
    
    // A function that returns whether a category name exists already or not
    func categoryExistsAlready(categoryName: String) -> Bool {
        if CoreDataHelper.categories.contains(where: {$0.name == categoryName}) {
            return true
        }
        return false
    }
    
    // Returns true if there is only one investment within a category - false otherwise
    func onlyOneInvestmentInOldCategory(categoryName: String) -> Bool {
        let investments = CoreDataHelper.investments.filter{$0.category?.name == categoryName}
        print(investments.count)
        if investments.count == 1 {
            return true
        }
        return false
    }
    
    // Renames the category of the selected investment to the given name
    func renameCategory(categoryName: String) {
        selectedInvestment?.category?.name = categoryName
    }
    
    // Deletes the passed category
    func deleteCategory(categoryName: String) {
        guard let context = CoreDataHelper.getContext() else {return}
        let investments = CoreDataHelper.investments.filter({$0.category?.name == categoryName})
        guard investments.count == 0 else {return}
        let categories = CoreDataHelper.categories.filter({$0.name == categoryName})
        guard categories.count == 1 else {return}
        context.delete(categories[0])
    }
    
    // This function creates a new category
    func createCategory(categoryName: String) {
        guard let context = CoreDataHelper.getContext() else {return}
        let newCategory = Category(context: context)
        newCategory.name = categoryName
        // append this new category to the array of categories
        CoreDataHelper.categories.append(newCategory)
    }
    
    // update everything of the investment except its name
    func updateInvestment() {
        selectedInvestment?.symbol = symbolTextField.stringValue
        selectedInvestment?.isin = isinTextField.stringValue
        selectedInvestment?.apiWebsite = apiPopUpButton.titleOfSelectedItem
    }
    
    // Make sure that the new investment name is not the name of an existing investment nor of a category that exists already or is being created.
    func newInvestmentNameIsValid(newInvestmentName: String) -> Bool {
        guard !CoreDataHelper.investments.contains(where: {$0.name == newInvestmentName}) else {return false}
        // Make sure that the new invsetment name is not the name of a category already
        guard !CoreDataHelper.categories.contains(where: {$0.name == newInvestmentName}) else {return false}
        // Make sure that the new investment name is not the same as chosen for the category
        guard categoryNameTextField.stringValue != newInvestmentName else {return false}
        return true
    }
    
    
}

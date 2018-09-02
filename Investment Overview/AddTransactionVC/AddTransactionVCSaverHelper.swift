//
//  AddTransactionVCSaverHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 22.08.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

extension AddTransactionVC {
    
    // Returns a category from a category name
    func getCategoryFromName(categoryName: String) -> Category? {
        let categoryArray = CoreDataHelper.categories.filter({$0.name == categoryName})
        guard categoryArray.count == 1 else {return nil}
        return categoryArray[0]
    }
    
    // Returns an investment from an investment name
    func getInvestmentFromName(investmentName: String) -> Investment? {
        let investmentArray = CoreDataHelper.investments.filter({$0.name == investmentName})
        print("There are \(investmentArray.count) investments")
        guard investmentArray.count == 1 else {return nil}
        return investmentArray[0]
    }
    
    // This function checks if a given investment already exist or is a new investment
    func isNewInvestment(investmentName: String) -> Bool {
        return !CoreDataHelper.investments.contains{$0.name == investmentName}
    }
    
    // This function checks if a given category already exist or is a new category
    func isNewCategory(categoryName: String) -> Bool {
        return !CoreDataHelper.categories.contains{$0.name == categoryName}
    }
    
    // This function creates a new category
    func createCategory(categoryName: String) {
        guard let context = CoreDataHelper.getContext() else {return}
        let newCategory = Category(context: context)
        newCategory.name = categoryName
        // append this new category to the array of categories
        CoreDataHelper.categories.append(newCategory)
    }
    
    // This function creates a new investment
    func createInvestment(within categoryName: String) {
        // get category from category name
        guard let categoryOfInvestment = getCategoryFromName(categoryName: categoryName) else {return}
        
        guard let context = CoreDataHelper.getContext() else {return}
        let newInvestment = Investment(context: context)
        newInvestment.name = investmentNamePopUpButton.titleOfSelectedItem
        newInvestment.symbol = symbolTextField.stringValue
        newInvestment.isin = isinTextField.stringValue
        // append this new investment to the array of investments - this makes sure it does not vanish after this function
        CoreDataHelper.investments.append(newInvestment)
        // link this investment to its category
        categoryOfInvestment.addToInvestments(newInvestment)
        // newInvestment.category = categoryOfInvestment - this line would probably also be possible but I do it the other way round
    }
    
    // This function creates a new transaction
    func createTransaction(belongingTo investmentName: String) {
        // get investment from investment name
        guard let investmentOfTransaction = getInvestmentFromName(investmentName: investmentName) else {return}
        
        guard let context = CoreDataHelper.getContext() else {return}
        let newTransaction = Transaction(context: context)
        newTransaction.unitsBought = unitsBoughtSoldTextField.doubleValue
        newTransaction.price = priceTextField.doubleValue
        newTransaction.date = datePicker.dateValue
        newTransaction.exchange = exchangeNameTextField.stringValue
        newTransaction.type = transactionTypePopUpButton.titleOfSelectedItem
        newTransaction.fees = feesTextField.doubleValue
        // append this new transaction to the array of transactions - this makes sure it does not vanish after this function
        CoreDataHelper.transactions.append(newTransaction)
        // link this transaction to its investment
        investmentOfTransaction.addToTransactions(newTransaction)
    }
    
    // This function checks that in the selected popUpButtons the investment actually belongs to the selected category
    func correctCategoryIsSelected(investmentName: String, categoryName: String) -> Bool {
        // get investment and category from names
        print("We are in the correctCategoryIsSelected function")
        guard let investment = getInvestmentFromName(investmentName: investmentName) else {return false}
        print("The investment is \(investment)")
        guard let category = getCategoryFromName(categoryName: categoryName) else {return false}
        print("The ")
        if investment.category == category {
            return true
        } else {
            return false
        }
    }
    
}

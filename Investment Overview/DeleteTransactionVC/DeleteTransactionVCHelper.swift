//
//  DeleteTransactionVCHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 28.08.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa


extension DeleteTransactionVC {
    
    func updateView() {
        // Check if a selection in the tableView was made
        guard transactionToDelete != nil else {
            confirmationLabel.stringValue = "No transaction selected"
            confirmButton.isEnabled = false
            return
        }
        
        // Check if a selection in the outlineView was made
        guard overviewVC?.outlineView.selectedRow != nil else {
            confirmationLabel.stringValue = "No investment or category selected - THIS SHOULD NEVER HAPPEN, PLEASE REPORT AS BUG"
            confirmButton.isEnabled = false
            return
        }
        
        // Now see if there is only one single transaction in the investment - in that case the complete Investment should be deleted
        switch isOnlyTransactionInInvestment(transaction: transactionToDelete) {
        case true:
            confirmationLabel.stringValue = "Are you sure you want to delete the investment '\(transactionToDelete?.investment?.name ?? "no name")'?\n\nThis action cannot be undone."
            confirmButton.isEnabled = true
        default:
            confirmationLabel.stringValue = "Are you sure you want to delete the transaction from \(transactionToDelete?.date?.description ?? "no date") over \(transactionToDelete?.unitsBought.description ?? "unknown amount") \(transactionToDelete?.investment?.symbol ?? "unknown symbol")?\n\nThis action cannot be undone."
            confirmationLabel.font = NSFont.boldSystemFont(ofSize: 12)
            confirmButton.isEnabled = true
        }
    }
    
    // This function is to check if the transaction is the only one in the investment
    func isOnlyTransactionInInvestment(transaction: Transaction?) -> Bool {
        guard let parentInvestment = transactionToDelete?.investment else {return false}
        switch parentInvestment.transactions?.allObjects.count {
        case 1: return true
        default: return false
        }
    }
    
    // This function checks if the transaction is the only one in the category
    func isOnlyInvestmentInCategory(transaction: Transaction?) -> Bool {
        guard let parentInvestment = transactionToDelete?.investment else {return false}
        guard let parentCategory = parentInvestment.category else {return false}
        switch parentCategory.investments?.allObjects.count {
        case 1: return true
        default: return false
        }
    }
    
    // This function removes a transaction from the transaction array
    func deleteTransaction(transaction: Transaction?) {
        guard transaction != nil else {return}
        guard let context = CoreDataHelper.getContext() else {return}
        context.delete(transaction!)
        // Now also delete it from the category array
        guard let indexToDelete = CoreDataHelper.transactions.index(of: transaction!) else {return}
        CoreDataHelper.transactions.remove(at: indexToDelete)
    }
    
    // This function removes an investment from the investment array, which is the parent of the transaction
    func deleteInvestment(transaction: Transaction?) {
        guard let investment = transaction?.investment else {return}
        guard let context = CoreDataHelper.getContext() else {return}
        context.delete(investment)
        // Now also delete it from the investment array
        guard let indexToDelete = CoreDataHelper.investments.index(of: investment) else {return}
        CoreDataHelper.investments.remove(at: indexToDelete)
    }
    
    // This function removes a category from the category array, which is the grandparent of the transaction
    func deleteCategory(transaction: Transaction?) {
        guard let investment = transaction?.investment else {return}
        guard let category = investment.category else {return}
        guard let context = CoreDataHelper.getContext() else {return}
        context.delete(category)
        // Now also delete it from the category array
        guard let indexToDelete = CoreDataHelper.categories.index(of: category) else {return}
        CoreDataHelper.categories.remove(at: indexToDelete)
    }
    
    
}

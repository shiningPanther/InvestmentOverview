//
//  OverviewVCHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 28.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation
import Cocoa

extension OverviewVC {
    
    func updateView() {
        // Reload the outline view and give the info to detailsVC to update its view accordingly
        outlineView.reloadData()
        // Enable or disable edit and delete buttons
        updateButtons()
        // Send selection to detailsVC
        passSelectionToDetailsVC()
        detailsVC?.updateView()
    }
    
    // This function disables the edit and delete buttons
    func disableButtons() {
        editButton.isEnabled = false
        deleteButton.isEnabled = false
    }
    
    // This function is called everytime that either the outlineView or tableView changes
    func updateButtons() {
        editButton.isEnabled = false
        deleteButton.isEnabled = false
        // Check if edit and delete buttons should be enabled - first check if there is a selection in the details view and then check if an investment is selected in the outline view
        guard let selectedRow = detailsVC?.tableView?.selectedRow else {return}
        if selectedRow >= 0 {
            if outlineView.selectedRow >= 0 {
                guard let name = outlineView.item(atRow: outlineView.selectedRow) as? String else {return}
                if CoreDataHelper.investments.contains(where: {$0.name == name}) {
                    editButton.isEnabled = true
                    deleteButton.isEnabled = true
                }
            }
        }
    }
    
    // This function is called everytime that the outlineView selection changes
    func passSelectionToDetailsVC() {
        let (selectedCategory, selectedInvestment, selectedTransactions) = getSelectedCategoryAndInvestment()
        detailsVC?.selectedCategory = selectedCategory
        detailsVC?.selectedInvestment = selectedInvestment
        detailsVC?.selectedTransactions = selectedTransactions
    }
    
    // This function is only called when the addTransaction button is clicked
    func passSelectionToAddTransactionVC(addTransactionVC: AddTransactionVC) {
        let (selectedCategory, selectedInvestment, _) = getSelectedCategoryAndInvestment()
        addTransactionVC.selectedCategory = selectedCategory
        addTransactionVC.selectedInvestment = selectedInvestment
        addTransactionVC.overviewVC = self
        addTransactionVC.detailsVC = detailsVC
    }
    
    // This function is only called when the deleteTransaction button is clicked
    func passSelectionToDeleteTransactionVC(deleteTransactionVC: DeleteTransactionVC) {
        // First assign the overviewVC and detailsVC, then the transaction
        // If one of the guards is not fulfilled it will assign nil to transactionToDelete
        deleteTransactionVC.overviewVC = self
        deleteTransactionVC.detailsVC = detailsVC
        // Check if a selection in the tableView was made
        guard let selectedRow = detailsVC?.tableView.selectedRow else {return}
        guard selectedRow >= 0 else {return}
        guard let transactionToDelete = detailsVC?.selectedTransactions?[selectedRow] else {return}
        deleteTransactionVC.transactionToDelete = transactionToDelete
    }
    // This function is only called when the editTransaction button is clicked
    func passSelectionToEditTransactionVC(editTransactionVC: EditTransactionVC) {
        // Assign detailsVC and overviewVC
        editTransactionVC.overviewVC = self
        editTransactionVC.detailsVC = detailsVC
        // Check if a selection in the tableView was made and assign the selected transaction
        guard let selectedRow = detailsVC?.tableView.selectedRow else {return}
        guard selectedRow >= 0 else {return}
        guard let selectedTransaction = detailsVC?.selectedTransactions?[selectedRow] else {return}
        editTransactionVC.selectedTransaction = selectedTransaction
        // Now assign the investment
        editTransactionVC.selectedInvestment = selectedTransaction.investment
    }
    
    // All of this might be better with an NSPanel...
    func getWC(identifier: String) -> NSWindowController? {
        guard let wc = storyboard?.instantiateController(withIdentifier: identifier) as? NSWindowController else {return nil}
        return wc
    }
    func getVC(wc: NSWindowController) -> NSViewController? {
        let vc = wc.contentViewController
        return vc
    }

    
    // Get the selected category and investment in order to give them to other VCs
    // Returns nil for selectedInvestment and selectedTransactions when a category is selected
    // Returns nil for selectedCategory when an investment is selected - returns then also all of the transactions of the investment
    // Returns nil, nil, nil if nothing is selected
    // It is important that the name of an investment can never be the name of a category!!!
    func getSelectedCategoryAndInvestment() -> (selectedCategory: Category?, selectedInvestment: Investment?, selectedTransactions: [Transaction]?){
        // If something is selected
        if outlineView.selectedRow >= 0 {
            guard let name = outlineView.item(atRow: outlineView.selectedRow) as? String else {return (nil, nil, nil)}
            switch CoreDataHelper.categories.contains(where: {$0.name == name}) {
            // true means that a category is selected -> return category name and nil for investment name
            case true:
                let categoryArray = CoreDataHelper.categories.filter({$0.name == name})
                if categoryArray.count == 1 {
                    return (categoryArray[0], nil, nil)
                } else {
                    return (nil, nil, nil)
                }
            // false means that an investment is selected -> return nil for category name and selected investment
            case false:
                let investmentArray = CoreDataHelper.investments.filter({$0.name == name})
                if investmentArray.count == 1 {
                    let selectedInvestment = investmentArray[0]
                    let selectedTransactions = CoreDataHelper.getTransactionsOfInvestment(investment: selectedInvestment)
                    return (nil, selectedInvestment, selectedTransactions)
                } else {
                    return (nil, nil, nil)
                }
            }
        }
        // If nothing is selected
        else {
            return (nil, nil, nil)
        }
    }
    
    func selectItem(item: String) {
        let row = outlineView.row(forItem: item)
        guard row >= 0 else {return}
        let indexSet = NSIndexSet(index: row)
        outlineView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: true)
    }
    
    func isInvestment(name: String) -> Bool {
        if CoreDataHelper.investments.contains(where: {$0.name == name}) {
            return true
        }
        return false
    }
    
    func isCategory(name: String) -> Bool {
        if CoreDataHelper.categories.contains(where: {$0.name == name}) {
            return true
        }
        return false
    }
    
    func updateInvestmentName(oldName: String, newName: String) {
        let investments = CoreDataHelper.investments.filter({$0.name == oldName})
        guard investments.count == 1 else {return}
        investments[0].name = newName
    }
    
    func updateCategoryName(oldName: String, newName: String) {
        let categories = CoreDataHelper.categories.filter({$0.name == oldName})
        guard categories.count == 1 else {return}
        categories[0].name = newName
    }
    
}


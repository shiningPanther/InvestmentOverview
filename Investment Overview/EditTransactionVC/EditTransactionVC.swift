//
//  EditTransactionVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 28.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

class EditTransactionVC: NSViewController {
    
    // The selected investment and transaction from the outlineView or tableView, respectively.
    // They get assigned when the view controller get initiated.
    var selectedInvestment: Investment?
    var selectedTransaction: Transaction?
    
    // Reference to OverviewVC and DetailsVC - gets initiated when the edit button is clicked
    var overviewVC: OverviewVC?
    var detailsVC: DetailsVC?
    
    @IBOutlet weak var investmentNameTextField: NSTextField!
    @IBOutlet weak var categoryNameTextField: NSTextField!
    @IBOutlet weak var isinTextField: NSTextField!
    @IBOutlet weak var symbolTextField: NSTextField!
    @IBOutlet weak var apiPopUpButton: NSPopUpButton!
    @IBOutlet weak var transactionTypePopUpButton: NSPopUpButton!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var exchangeNameTextField: NSTextField!
    @IBOutlet weak var unitsBoughtTextField: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var feesTextField: NSTextField!
    
    
    // We need to do the view setup in the viewWillAppear since viewDidLoad is called when the WC is initiated and the instances are not available yet
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        updateView()
    }
    
    // check which property is changed and then change the context accordingly
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        // Here, all the values of the transaction are updated according to the text fields.
        updateTransaction()
        
        // Here, everything of the investment gets updated, except for its name.
        updateInvestment()
        
        let newInvestmentName = investmentNameTextField.stringValue
        guard let oldInvestmentName = selectedInvestment?.name else {return}
        
        // Now, we update the investment name
        if newInvestmentName != oldInvestmentName {
            // Make sure that the new investment name is not the name of an existing investment or category (including one that is being created) already
            if newInvestmentNameIsValid(newInvestmentName: newInvestmentName) {
                selectedInvestment?.name = newInvestmentName
            }
        }
        
        // Now let's go to the categories...
        let newCategoryName = categoryNameTextField.stringValue
        guard let oldCategoryName = selectedInvestment?.category?.name else {return}

        // Now, when the category names have changed
        if oldCategoryName != newCategoryName {
            
            // Check that the category name is not the name of any investment (including a possible renaming)
            guard newCategoryNameIsValid(newCategoryName: newCategoryName) else {return}
            
            // The new category exists already
            if categoryExistsAlready(categoryName: newCategoryName) {
                
                // If there is only one investment in the old category:
                // Update to which category belongs the investment and delete this category afterwards.
                if onlyOneInvestmentInOldCategory(categoryName: oldCategoryName) {
                    updateCategory(categoryName: newCategoryName)
                    deleteCategory(categoryName: oldCategoryName)
                }
                // If there are several invsetments in one category:
                // Update to which category the investment belongs to and don't delete the category afterwards.
                else {
                    updateCategory(categoryName: newCategoryName)
                }
            }
                
            // The new category does not exist yet and still needs to be created
            else {
                // If there is only one investment it is only a renaming and no creation of a category is needed.
                if onlyOneInvestmentInOldCategory(categoryName: oldCategoryName) {
                    renameCategory(categoryName: newCategoryName)
                }
                // If there are several investments in the old category, create a new category and update the category of this one investment.
                else {
                    createCategory(categoryName: newCategoryName)
                    updateCategory(categoryName: newCategoryName)
                }
            }
            
        }
        
        CoreDataHelper.sortTransactions()
        SortAndCalculate.calculateAllProfits()
        
        CoreDataHelper.save()

        overviewVC?.updateView()
        overviewVC?.outlineView.expandItem(newCategoryName)
        overviewVC?.selectItem(item: newInvestmentName)
        
        view.window?.close()
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
    
}

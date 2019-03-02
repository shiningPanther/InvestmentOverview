//
//  AddTransactionVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 06.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa


class AddTransactionVC: NSViewController {
    
    // These are the values selected in the outlineView. They are passed when the addButton is clicked
    var selectedInvestment: Investment?
    var selectedCategory: Category?
    
    // Reference to OverviewVC and DetailsVC - gets initiated when the addTransactionButton is clicked
    var overviewVC: OverviewVC?
    var detailsVC: DetailsVC?
    
    @IBOutlet weak var transactionTypePopUpButton: NSPopUpButton!
    @IBOutlet weak var investmentCategoryPopUpButton: NSPopUpButton!
    @IBOutlet weak var investmentCategoryTextField: NSTextField!
    @IBOutlet weak var investmentCategoryAddButton: NSButton!
    @IBOutlet weak var investmentNamePopUpButton: NSPopUpButton!
    @IBOutlet weak var investmentNameTextField: NSTextField!
    @IBOutlet weak var investmentNameAddButton: NSButton!
    @IBOutlet weak var symbolTextField: NSTextField!
    @IBOutlet weak var isinTextField: NSTextField!
    @IBOutlet weak var apiPopUpButton: NSPopUpButton!
    @IBOutlet weak var unitsBoughtSoldLabel: NSTextField!
    @IBOutlet weak var unitsBoughtSoldTextField: NSTextField!
    @IBOutlet weak var priceLabel: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var feesLabel: NSTextField!
    @IBOutlet weak var feesTextField: NSTextField!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var exchangeNameTextField: NSTextField!
    
    // The viewDidLoad function is already called when the window controller is instantiated. At this moment overviewVC is still nil... Do view setup in the viewWillAppear function
    // I am calling updateView() from the overviewVC
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func transactionTypePopUpButtonChanged(_ sender: Any) {
        if transactionTypePopUpButton.titleOfSelectedItem == "Buy" || transactionTypePopUpButton.titleOfSelectedItem == "Sell" {
            makeBuySellView()
        }
        if transactionTypePopUpButton.titleOfSelectedItem == "Airdrop" {
            // The first makeBuySellView ensures that we do not get something weird when changing from Dividends to Airdrop for example...
            makeBuySellView()
            makeAirdropView()
        }
        if transactionTypePopUpButton.titleOfSelectedItem == "Dividends" {
            makeBuySellView()
            makeDividendsView()
        }
    }
    
    @IBAction func categoryTextFieldEdited(_ sender: NSTextField) {
        investmentCategoryAddButtonClicked(self)
    }
    
    @IBAction func investmentCategoryAddButtonClicked(_ sender: Any) {
        // Add the text of the text field to the investment category pop up button and make it active
        let title = investmentCategoryTextField.stringValue
        if title != "" {
            investmentCategoryTextField.stringValue = ""
            investmentCategoryPopUpButton.addItem(withTitle: title)
            investmentCategoryPopUpButton.selectItem(withTitle: title)
            // New category -- remove everything related to investments
            investmentNamePopUpButton.removeAllItems()
            removeAllInvestmentFields()
        }
    }
    
    @IBAction func investmentCategoryPopUpButtonChanged(_ sender: Any) {
        // Populate the investmentName pop up button
        investmentNamePopUpButton.removeAllItems()
        removeAllInvestmentFields()
        guard let categoryName = investmentCategoryPopUpButton.titleOfSelectedItem else {return}
        investmentNamePopUpButton.addItems(withTitles: getInvestmentNames(categoryName: categoryName))
        investmentNamePopUpButton.selectItem(at: -1)
    }
    
    @IBAction func investmentNameAddButtonClicked(_ sender: Any) {
        // Add the value of the text field to the investment name pop up button and make it active
        removeAllInvestmentFields()
        let title = investmentNameTextField.stringValue
        if title != "" {
            investmentNameTextField.stringValue = ""
            investmentNamePopUpButton.addItem(withTitle: title)
            investmentNamePopUpButton.selectItem(withTitle: title)
        }
    }
    
    @IBAction func investmentTextFieldEdited(_ sender: NSTextField) {
        investmentNameAddButtonClicked(self)
    }
    
    @IBAction func investmentNamePopUpButtonChanged(_ sender: Any) {
        removeAllInvestmentFields()
        // get the string of the pop up button
        guard let name = investmentNamePopUpButton.titleOfSelectedItem else {return}
        // get the Investment from this string and pass it to the updateTextFieldsForInvestment function
        let investmentArray = CoreDataHelper.investments.filter({$0.name == name})
        if investmentArray.count == 1 {
            updateTextFieldsForInvestment(investment: investmentArray[0])
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        // An investment is identified by its name - This name has to be unique and cannot exist as a category name
        // Make also sure that a category name and an investment name are selected
        guard let investmentName = investmentNamePopUpButton.titleOfSelectedItem else {return}
        guard let categoryName = investmentCategoryPopUpButton.titleOfSelectedItem else {return}
        guard transactionTypePopUpButton.titleOfSelectedItem != nil else {return}
        
        if AddTransactionVC.isNewInvestment(investmentName: investmentName) {
            // Make sure that the investment name is not the name of a category already
            guard !CoreDataHelper.categories.contains(where: {$0.name == investmentName}) else {return}
            // Make sure that the investment name is not the same name as the selected category
            guard investmentCategoryPopUpButton.titleOfSelectedItem != investmentName else {return}
            if isNewCategory(categoryName: categoryName) {
                createCategory(categoryName: categoryName)
                createInvestment(within: categoryName)
                createTransaction(belongingTo: investmentName)
            } else if !isNewCategory(categoryName: categoryName) {
                createInvestment(within: categoryName)
                createTransaction(belongingTo: investmentName)
            }
        } else if !AddTransactionVC.isNewInvestment(investmentName: investmentName) {
            // Make sure that the correct category of the investment is selected, i.e. that there cannot be an investment in two categories
            guard correctCategoryIsSelected(investmentName: investmentName, categoryName: categoryName) else {return}
            createTransaction(belongingTo: investmentName)
        }
        
        // Now we only need to save, update the views and close the window...
        
        CoreDataHelper.save()
        
        CoreDataHelper.sortTransactions() // sorts transactions, investments and categories
        SortAndCalculate.calculateAllProfits()
        
        overviewVC?.updateView() // This should work correctly as the nameArrays are already updated
        // In order to update the detailsVC we need to pass it the correct category and investment first. Since we just created a transaction we can be sure that an investment is selected
        //detailsVC?.selectedCategory = nil
        //detailsVC?.selectedInvestment = getInvestmentFromName(investmentName: investmentName)
        //detailsVC?.updateView()
        // The detailsVC gets updated when a new item in the outlineView gets selected
        let selectedRow = overviewVC?.outlineView.row(forItem: investmentName)
        overviewVC?.outlineView.selectRowIndexes(NSIndexSet(index: selectedRow ?? 0) as IndexSet, byExtendingSelection: false)
        
        view.window?.close()
    }
        
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
    
}

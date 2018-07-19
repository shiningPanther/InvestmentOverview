//
//  AddTransactionVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 06.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa


class AddTransactionVC: NSViewController {
    
    var transactions: [Transaction2]?
    var categoryNames: [String]?
    var investmentNames: [String: [String]]?
    
    // Reference to OverviewVC and DetailsVC - gets initiated when this window shows up
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
    @IBOutlet weak var unitsBoughtSoldTextField: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var exchangeNameTextField: NSTextField!
    
    // The viewDidLoad function is already called when the window controller is instantiated. At this moment overviewVC is still nil... Do view setup in the viewWillAppear function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        updateView()
    }
    
    func updateView() {
        // assign variables from overviewVC -> Context does not need to be asked again
        transactions = overviewVC?.transactions
        categoryNames = overviewVC?.categoryNames
        investmentNames = overviewVC?.investmentNames
        
        // check that the assignment went correctly
        guard transactions != nil else {
            print("Transactions could not be assigned")
            return
        }
        guard categoryNames != nil else {
            print("Category names could not be assigned")
            return
        }
        guard investmentNames != nil else {
            print("Investment names could not be assigned")
            return
        }
        
        // Populate the investmentCategory pop up button
        investmentCategoryPopUpButton.addItems(withTitles: categoryNames!)
        // Choose the displayed category as the item that was selected in the outline view
        // Get the values from the DetailsVC
        if let categoryTitle = detailsVC?.selectedCategory {
            investmentCategoryPopUpButton.selectItem(withTitle: categoryTitle)
            guard let investmentTitles = investmentNames?[categoryTitle] else {return}
            investmentNamePopUpButton.addItems(withTitles: investmentTitles)
        } else if let investment = detailsVC?.selectedInvestment {
            guard let categoryTitle = investment.categoryName else {return}
            investmentCategoryPopUpButton.selectItem(withTitle: categoryTitle)
            guard let investmentTitles = investmentNames?[categoryTitle] else {return}
            investmentNamePopUpButton.addItems(withTitles: investmentTitles)
            investmentNamePopUpButton.selectItem(withTitle: investment.investmentName!)
        }
        
        // Set the date to the current date
        datePicker.dateValue = Date()
    }
    
    
    @IBAction func investmentCategoryAddButtonClicked(_ sender: Any) {
        // Add the value of the text field to the investment category pop up button and make it active
        let title = investmentCategoryTextField.stringValue
        if title != "" {
            investmentCategoryTextField.stringValue = ""
            investmentCategoryPopUpButton.addItem(withTitle: title)
            investmentCategoryPopUpButton.selectItem(withTitle: title)
        }
    }
    
    @IBAction func investmentCategoryPopUpButtonChanged(_ sender: Any) {
        // Populate the investmentCategory pop up button
        investmentNamePopUpButton.removeAllItems()
        guard let categoryTitle = investmentCategoryPopUpButton.titleOfSelectedItem else {return}
        guard let investmentTitles = investmentNames?[categoryTitle] else {return}
        investmentNamePopUpButton.addItems(withTitles: investmentTitles)
    }
    
    @IBAction func investmentNameAddButtonClicked(_ sender: Any) {
        // Add the value of the text field to the investment name pop up button and make it active
        let title = investmentNameTextField.stringValue
        if title != "" {
            investmentNameTextField.stringValue = ""
            investmentNamePopUpButton.addItem(withTitle: title)
            investmentNamePopUpButton.selectItem(withTitle: title)
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        // A transaction is identified by its investmentName - This name has to be unique and cannot exist as a category name
        // Make also sure that a category name and an investment name are selected
        guard let investmentName = investmentNamePopUpButton.titleOfSelectedItem else {return}
        guard investmentCategoryPopUpButton.titleOfSelectedItem != nil else {return}
        // Get only the tansaction with the name that is trying to be saved - the filter function returns an array with the selected criteria. The array is empty if it is a new transaction
        guard let transactionArray = transactions?.filter({$0.investmentName == investmentName}) else {return}
        
        // if transactionArray is an empty array then it is a new transaction
        if transactionArray == [] {
            // Make sure that the investment name is not the name of a category already
            guard categoryNames != nil else {return}
            guard !categoryNames!.contains(investmentName) else {return}
            // Make sure that the investment name is not the same name as the selected category
            guard investmentCategoryPopUpButton.titleOfSelectedItem != nil else {return}
            guard investmentCategoryPopUpButton.titleOfSelectedItem != investmentName else {return}
            
            guard let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else{return}
            let newTransaction = Transaction2(context: context)
            
            // First the properties that only have one value
            newTransaction.categoryName = investmentCategoryPopUpButton.titleOfSelectedItem
            newTransaction.investmentName = investmentNamePopUpButton.titleOfSelectedItem
            newTransaction.investmentSymbol = symbolTextField.stringValue
            newTransaction.investmentISIN = isinTextField.stringValue
            
            // Now the arrays
            newTransaction.unitsBought = [unitsBoughtSoldTextField.doubleValue]
            newTransaction.priceEUR = [priceTextField.doubleValue]
            newTransaction.date = [datePicker.dateValue]
            newTransaction.exchange = [exchangeNameTextField.stringValue]
            
            // Save, update overviewVC and close window
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            overviewVC?.updateView()
            view.window?.close()
        }
        
        // if the transaction exists already
        if transactionArray.count == 1 {
            let transaction = transactionArray[0]
            // Make sure that the same investment name does not exist in a different category already.
            // Actually this only is a warning - The transaction would be appended to the category that it was selected originally...
            guard transaction.categoryName == investmentCategoryPopUpButton.titleOfSelectedItem else {return}
            
            // Only the arrays need to be updated
            // Add them at the 'right' position in ascending chronological order
            let date = datePicker.dateValue
            // If there exists a larger date in the array already add the element at the index before that
            if let firstLargerDate = transaction.date?.first(where: {$0 > date}) {
                guard let firstLargerIndex = transaction.date?.index(of: firstLargerDate) else {return}
                transaction.date?.insert(date, at: firstLargerIndex)
                transaction.unitsBought?.insert(unitsBoughtSoldTextField.doubleValue, at: firstLargerIndex)
                transaction.priceEUR?.insert(priceTextField.doubleValue, at: firstLargerIndex)
                transaction.exchange?.insert(exchangeNameTextField.stringValue, at: firstLargerIndex)
            }
            // Otherwise this is the latest transaction - just append everything
            else {
                transaction.unitsBought?.append(unitsBoughtSoldTextField.doubleValue)
                transaction.priceEUR?.append(priceTextField.doubleValue)
                transaction.date?.append(datePicker.dateValue)
                transaction.exchange?.append(exchangeNameTextField.stringValue)
            }
            
            // Save, update overviewVC and close window
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            overviewVC?.updateView()
            detailsVC?.updateView()
            view.window?.close()
        }
    }
        
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
    
}

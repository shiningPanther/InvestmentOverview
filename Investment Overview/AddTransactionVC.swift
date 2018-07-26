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
    var selectedInvestment: Transaction2?
    var selectedCategory: String?
    
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
    @IBOutlet weak var apiPopUpButton: NSPopUpButton!
    @IBOutlet weak var unitsBoughtSoldTextField: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var feesTextField: NSTextField!
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
        investmentCategoryPopUpButton.selectItem(at: -1)
        
        // Show an item in the investment category pop up button if either an investment or category are selected
        if selectedCategory != nil {
            investmentCategoryPopUpButton.selectItem(withTitle: selectedCategory!)
        }
        if selectedInvestment != nil {
            let categoryName = selectedInvestment?.categoryName ?? "Empty category"
            investmentCategoryPopUpButton.selectItem(withTitle: categoryName)
            // Now also populate the investment name pop up button
            if let investmentTitles = investmentNames?[categoryName] {
                investmentNamePopUpButton.addItems(withTitles: investmentTitles)
            }
            if let name = selectedInvestment?.investmentName {
                investmentNamePopUpButton.selectItem(withTitle: name)
                // Populate all other fields
                showTextFieldsForInvestment(investmentName: name)
            }
        }
        // Set the date to the current date
        datePicker.dateValue = Date()
    }
    
    func showTextFieldsForInvestment(investmentName: String) {
        guard let transactionArray = transactions?.filter({$0.investmentName == investmentName}) else {return}
        guard transactionArray.count == 1 else {return}
        let transaction = transactionArray[0]
        
        // Populate all relevant fields
        if let name = transaction.investmentName {
            investmentNamePopUpButton.selectItem(withTitle: name)
        }
        if let symbol = transaction.investmentSymbol {
            symbolTextField.stringValue = symbol
        }
        if let isin = transaction.investmentISIN {
            isinTextField.stringValue = isin
        }
        if let api = transaction.apiWebsite {
            apiPopUpButton.addItem(withTitle: api)
            apiPopUpButton.selectItem(withTitle: api)
        }
    }
    
    func removeAllInvestmentFields() {
        symbolTextField.stringValue = ""
        isinTextField.stringValue = ""
        apiPopUpButton.selectItem(at: -1)
    }
    
    
    @IBAction func investmentCategoryAddButtonClicked(_ sender: Any) {
        // Add the value of the text field to the investment category pop up button and make it active
        let title = investmentCategoryTextField.stringValue
        if title != "" {
            investmentCategoryTextField.stringValue = ""
            investmentCategoryPopUpButton.addItem(withTitle: title)
            investmentCategoryPopUpButton.selectItem(withTitle: title)
            // New category -- remove all
            investmentNamePopUpButton.removeAllItems()
            removeAllInvestmentFields()
        }
    }
    
    @IBAction func investmentCategoryPopUpButtonChanged(_ sender: Any) {
        // Populate the investmentName pop up button
        investmentNamePopUpButton.removeAllItems()
        removeAllInvestmentFields()
        guard let categoryTitle = investmentCategoryPopUpButton.titleOfSelectedItem else {return}
        guard let investmentTitles = investmentNames?[categoryTitle] else {return}
        investmentNamePopUpButton.addItems(withTitles: investmentTitles)
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
    
    @IBAction func investmentNamePopUpButtonChanged(_ sender: Any) {
        removeAllInvestmentFields()
        guard let name = investmentNamePopUpButton.titleOfSelectedItem else {return}
        showTextFieldsForInvestment(investmentName: name)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        // A transaction is identified by its investmentName - This name has to be unique and cannot exist as a category name
        // Make also sure that a category name and an investment name are selected
        guard let investmentName = investmentNamePopUpButton.titleOfSelectedItem else {return}
        guard investmentCategoryPopUpButton.titleOfSelectedItem != nil else {return}
        guard transactionTypePopUpButton.titleOfSelectedItem != nil else {return}
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
            newTransaction.type = [transactionTypePopUpButton.titleOfSelectedItem] as? [String]
            newTransaction.fees = [feesTextField.doubleValue]
            
            // Now calculate the profits
            calculateProfits(transaction: newTransaction)
            
            // Save, update overviewVC and close window
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            overviewVC?.updateView()
            // A new transaction was created - show it directly in the detailsVC
            detailsVC?.selectedCategory = nil
            detailsVC?.selectedInvestment = newTransaction
            detailsVC?.updateView()
            // Also select the transaction in the outline view of the overviewVC
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
                transaction.type?.insert(transactionTypePopUpButton.stringValue, at: firstLargerIndex)
                transaction.fees?.insert(feesTextField.doubleValue, at: firstLargerIndex)
            }
            // Otherwise this is the latest transaction - just append everything
            else {
                transaction.unitsBought?.append(unitsBoughtSoldTextField.doubleValue)
                transaction.priceEUR?.append(priceTextField.doubleValue)
                transaction.date?.append(datePicker.dateValue)
                transaction.exchange?.append(exchangeNameTextField.stringValue)
                transaction.type?.append(transactionTypePopUpButton.titleOfSelectedItem!)
                transaction.fees?.append(feesTextField.doubleValue)
            }
            
            // Now calculate the profits
            calculateProfits(transaction: transaction)
            
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

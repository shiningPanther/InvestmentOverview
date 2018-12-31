//
//  DeleteInvestmentVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 09.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

class DeleteTransactionVC: NSViewController {
    
    // Reference to the transaction that should be deleted - passed by OverviewVC when the deleteButton is pushed - this is the selected transaction in the DetailsVC tableView
    var transactionToDelete: Transaction?
    
    // Reference to OverviewVC and DetailsVC - gets initiated when this window shows up
    var overviewVC: OverviewVC?
    var detailsVC: DetailsVC?
    
    @IBOutlet weak var confirmationLabel: NSTextField!
    @IBOutlet weak var confirmButton: NSButton!
    
    // The viewDidLoad function is already called when the window controller is instantiated. At this moment overviewVC and detailsVC are still nil... Do view setup in the viewWillAppear function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        updateView()
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        // Check if there is only a single transaction in the investment to delete
        switch isOnlyTransactionInInvestment(transaction: transactionToDelete) {
        
        // It is not the only transaction
        case false:
            // Only delete the transaction
            deleteTransaction(transaction: transactionToDelete)
            
        // It is the only transaction
        case true:
            // Delete the transaction, investment and eventually category
            deleteTransaction(transaction: transactionToDelete)
            deleteInvestment(transaction: transactionToDelete)
            if isOnlyInvestmentInCategory(transaction: transactionToDelete) {
                deleteCategory(transaction: transactionToDelete)
            }
        }
        
        print("Before save action")
        for category in CoreDataHelper.categories {
            print(category.name)
        }
        for investment in CoreDataHelper.investments {
            print(investment.name)
        }
        print(CoreDataHelper.transactions.count)
        
        // save the changes
        CoreDataHelper.save()
        
        print("After save action")
        for category in CoreDataHelper.categories {
            print(category.name)
        }
        for investment in CoreDataHelper.investments {
            print(investment.name)
        }
        print(CoreDataHelper.transactions.count)
        
        CoreDataHelper.sortTransactions()
        SortAndCalculate.calculateAllProfits()
        
        // update overviews
        overviewVC?.updateView()
        detailsVC?.updateView()
        // Close window
        view.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
}

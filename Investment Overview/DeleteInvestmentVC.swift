//
//  DeleteInvestmentVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 09.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

class DeleteInvestmentVC: NSViewController {
    
    var transactionToDelete: Transaction2?
    var investmentContainsOneSingleTransaction = false
    
    // Reference to OverviewVC and DetailsVC - get initiated when this window shows up
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
    
    func updateView() {
        // Check if a selection in the tableView was made
        guard let selectedRowTableView = detailsVC?.tableView.selectedRow else {return}
        guard selectedRowTableView >= 0 else {
            confirmationLabel.stringValue = "No transaction selected"
            confirmButton.isEnabled = false
            return
        }
        
        // Check if a selection in the outlineView was made
        guard let selectedRowOutlineView = overviewVC?.outlineView.selectedRow else {
            confirmationLabel.stringValue = "No transaction selected"
            confirmButton.isEnabled = false
            return
        }
        guard let investmentToDeleteString = overviewVC?.outlineView.item(atRow: selectedRowOutlineView) as? String else {return}
        
        // Get the correct Transaction2
        guard let investmentToDeleteArray = overviewVC?.transactions.filter({$0.investmentName == investmentToDeleteString}) else {return}
        guard investmentToDeleteArray.count == 1 else {return}
        transactionToDelete = investmentToDeleteArray[0]
        
        // Now see if there is only one single transaction in the transactions array - in that case the complete Transaction2 should be deleted
        switch transactionToDelete?.date?.count {
        case 1:
            investmentContainsOneSingleTransaction = true
            confirmationLabel.stringValue = "Are you sure you want to delete the investment '\(investmentToDeleteString)'?\n\nThis action cannot be undone."
            confirmButton.isEnabled = true
        default:
            confirmationLabel.stringValue = "Are you sure you want to delete the transaction from \(transactionToDelete?.date?[selectedRowTableView].description ?? "no date") over \(transactionToDelete?.unitsBought?[selectedRowTableView].description ?? "unknown amount") \(transactionToDelete?.investmentSymbol ?? "unknown symbol")?\n\nThis action cannot be undone."
            confirmationLabel.font = NSFont.boldSystemFont(ofSize: 12)
            confirmButton.isEnabled = true
        }
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        // Check if there is only a single transaction in the investment to delete
        switch investmentContainsOneSingleTransaction {
        // Only one transaction in the investment to delete
        case true:
            // Delete the item from core data
            guard let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
            guard transactionToDelete != nil else {return}
            context.delete(transactionToDelete!)
        // Several transaction in the investment to delete
        default:
            // Delete the items in each array that the transaction has
            guard let selectedRow = detailsVC?.tableView.selectedRow else {return}
            guard selectedRow >= 0 else {return}
            transactionToDelete?.unitsBought?.remove(at: selectedRow)
            transactionToDelete?.date?.remove(at: selectedRow)
            transactionToDelete?.fees?.remove(at: selectedRow)
            transactionToDelete?.exchange?.remove(at: selectedRow)
            transactionToDelete?.type?.remove(at: selectedRow)
            transactionToDelete?.priceEUR?.remove(at: selectedRow)
        }
        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)

        // Update the Overview
        print("The transaction has been deleted. Update overviewVC is now being called")
        overviewVC?.updateView()
        print("Update overviewVC has finished. Update detailsVC is now being called")
        detailsVC?.updateView()
        print("Update detailsVC has finished")
        
        // Close window
        view.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
}

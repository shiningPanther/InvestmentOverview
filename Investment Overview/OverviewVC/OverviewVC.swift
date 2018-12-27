//
//  OverviewVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 24.06.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

class OverviewVC: NSViewController {
    
    // detailsVC is initialized by the the SplitController
    var detailsVC: DetailsVC?
    
    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        print("Done with OverviewVC viewDidLoad")
        super.viewDidLoad()
    }
    
    // I do the view setup in the viewWillAppear function since in the viewDidLoad function the detailsVC is still nil and it needs to be accessed by updateView function
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Debugging -- Delete investments from the Core Data if needed
        //Debugging.deleteTransactionsOfInvestment(investmentName: "zzz")
        //Debugging.deleteInvestment(investmentName: "zzz")
        
        updateView()
        print(CoreDataHelper.transactions.count)
    }
    
    // Every time the selection in the outline view changes, enable or disable the buttons
    // Also change the details view and give the selected investment / category to the DetailsVC
    func outlineViewSelectionDidChange(_ notification: Notification) {
        // Update the buttons - after a new selection within the outline view they should always be disabled...
        disableButtons()
        // Give info to detailsVC
        passSelectionToDetailsVC()
        detailsVC?.updateView()
    }
    
    
    @IBAction func addTransactionButtonClicked(_ sender: Any) {
        guard let wc = getWC(identifier: "addTransactionWC") else {return}
        guard let vc = getVC(wc: wc) as? AddTransactionVC else {return}
        passSelectionToAddTransactionVC(addTransactionVC: vc)
        vc.updateView()
        wc.showWindow(nil)
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        guard let wc = getWC(identifier: "confirmDeleteWC") else {return}
        guard let vc = getVC(wc: wc) as? DeleteTransactionVC else {return}
        passSelectionToDeleteTransactionVC(deleteTransactionVC: vc)
        vc.updateView()
        wc.showWindow(nil)
    }
    
    @IBAction func editTransactionButtonClicked(_ sender: Any) {
        guard let wc = getWC(identifier: "editTransactionWC") else {return}
        guard let vc = getVC(wc: wc) as? EditTransactionVC else {return}
        passSelectionToEditTransactionVC(editTransactionVC: vc)
        vc.updateView()
        wc.showWindow(nil)
    }

    @IBAction func finishedEditing(_ sender: NSTextField) {
        // oldName is the name in the text field displayed before editing
        guard let oldName = outlineView.item(atRow: outlineView.selectedRow) as? String else {return}
        // sender.stringValue is the name after editing the outline view
        let newName = sender.stringValue
        
        // if nothing has changed do nothing
        if newName == oldName {}
        // if the new name is empty revoke changes
        else if newName == "" {
            updateView() // This does not save the changes -- the original name should be displayed again
            selectItem(item: oldName)
        }
        // Make sure that the new name is not the name of an investment or category already
        else if isInvestment(name: newName) || isCategory(name: newName) {
            updateView() // This does not save the changes -- the original name should be displayed again
            selectItem(item: oldName)
        }
        // Something valid has changed
        else {
            if isInvestment(name: oldName) {
                updateInvestmentName(oldName: oldName, newName: newName)
            }
            else if isCategory(name: oldName) {
                updateCategoryName(oldName: oldName, newName: newName)
            }
            CoreDataHelper.save()
            updateView()
            selectItem(item: newName)
        }
    }
}

//
//  DeleteInvestmentVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 09.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

class DeleteInvestmentVC: NSViewController {
    
    var itemToDelete: String?
    
    // Reference to OverviewVC - gets initiated when this window shows up
    var overviewVC: OverviewVC?
    
    @IBOutlet weak var confirmationLabel: NSTextField!
    @IBOutlet weak var confirmButton: NSButton!
    
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
        guard let selectedRow = overviewVC?.outlineView.selectedRow else {return}
        // No row selected gives index -1
        if selectedRow >= 0 {
            guard let selectedItem = overviewVC?.outlineView.item(atRow: selectedRow) as? String else {return}
            // Check if a category was selected
            if (overviewVC?.categoryNames.contains(selectedItem))! {
                confirmationLabel.stringValue = "Cannot delete categories"
                confirmButton.isEnabled = false
            }
            else {
                itemToDelete = selectedItem
                confirmationLabel.stringValue = "Are you sure you want to delete the investment '\(selectedItem)' and all the transactions contained therein?\n\nThis action cannot be undone."
                confirmationLabel.font = NSFont.boldSystemFont(ofSize: 12)
                confirmButton.isEnabled = true
            }
        }
        // No row was selected
        else {
            confirmationLabel.stringValue = "No investment selected"
            confirmButton.isEnabled = false
        }
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        // Delete the item from core data
        guard let itemToDeleteArray = overviewVC?.transactions.filter({$0.investmentName == itemToDelete}) else {return}
        guard itemToDeleteArray.count == 1 else {return}
        guard let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
        context.delete(itemToDeleteArray[0])
        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
        
        // Update the Overview
        overviewVC?.updateView()
        
        // Close window
        view.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
}

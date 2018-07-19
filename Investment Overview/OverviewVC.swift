//
//  OverviewVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 24.06.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

class OverviewVC: NSViewController {
    
    var transactions: [Transaction2] = []
    var categoryNames: [String] = []
    var investmentNames: [String: [String]] = [:]
    var detailsVC: DetailsVC?
    
    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        // Get the context and initalize the categoryNames and investmentNames
        guard let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
        do {
            transactions = try context.fetch(Transaction2.fetchRequest()) as [Transaction2]
        } catch{}
        (categoryNames, investmentNames) = countInvestmentsAndCategories(transactions: transactions)
        
        // Check if edit and delete buttons should be enabled
        switch (outlineView.selectedRow) {
        case -1:
            editButton.isEnabled = false
            deleteButton.isEnabled = false
        default:
            editButton.isEnabled = true
            deleteButton.isEnabled = true
        }

        // Reload the outline view
        outlineView.reloadData()
    }
    
    // Every time the selection in the outline view changes, enable or disable the buttons
    // Also change the details view and give the selected investment / category to the DetailsVC
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if outlineView.selectedRow >= 0 {
            editButton.isEnabled = true
            deleteButton.isEnabled = true
            guard let name = outlineView.item(atRow: outlineView.selectedRow) as? String else {return}
            switch (categoryNames.contains(name)) {
            // true means that a category is selected
            case true:
                detailsVC?.selectedCategory = name
                detailsVC?.selectedInvestment = nil
            // false means that an investment is selected
            case false:
                detailsVC?.selectedCategory = nil
                let investmentArray = transactions.filter({$0.investmentName == name})
                guard investmentArray.count == 1 else {
                    detailsVC?.selectedInvestment = nil
                    return
                }
                detailsVC?.selectedInvestment = investmentArray[0]
            }
        }
        else {
            editButton.isEnabled = false
            deleteButton.isEnabled = false
            detailsVC?.selectedCategory = nil
            detailsVC?.selectedInvestment = nil
        }
        detailsVC?.updateView()
    }
    
    
    @IBAction func addTransactionButtonClicked(_ sender: Any) {
        guard let addTransactionWC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "addTransactionWC")) as? NSWindowController else {return}
        guard let addTransactionVC = addTransactionWC.contentViewController as? AddTransactionVC else {return}
        // This line assures that we can access the properties of this instance, ie the transactions etc
        addTransactionVC.overviewVC = self
        addTransactionVC.detailsVC = detailsVC
        addTransactionWC.showWindow(nil)
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        guard let confirmDeleteWC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "confirmDeleteWC")) as? NSWindowController else {return}
        guard let confirmDeleteVC = confirmDeleteWC.contentViewController as? DeleteInvestmentVC else {return}
        // This line assures that we can access the properties of this instance, ie the transactions etc
        confirmDeleteVC.overviewVC = self
        confirmDeleteWC.showWindow(nil)
    }
    
}




extension OverviewVC: NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    // Several functions are called when creating an outlineView. However not all the data is generated immediately but always only the visible data. The functions are then called again when new data gets displayed.
    
    // This method is called first when creating an outlineView
    // Each row has a unique identifier, referred to as item
    // First, tell how many children each row has:
    //    * The root has the identifier nil (item == nil)
    //    * The root has as many children as there are items in the first visible layer
    //    * Each sequent layer has as many children as there are objects when the view is expanded
    // The child is later on called by index in the subsequent functions
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return categoryNames.count
        } else if let item = item as? String {
            return (investmentNames[item]?.count ?? 0)
        }
        return 0
    }


    // This method is called second when creating an outlineView
    // Here, we give each row a unique identifier
    // The function is first called for index = 0, then the next functions are called until index = numberOfChildren
    // item == nil means it's the "root" row of the outline view, which is not visible
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return categoryNames[index]
        } else if let item = item as? String {
            return investmentNames[item]?[index] ?? ""
        }
        return ""
    }
    
    // This method is called third when creating an outlineView
    // Set the text for each row and column
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var text = ""
        if let columnIdentifier = tableColumn?.identifier.rawValue, columnIdentifier == "investmentColumn" {
            guard let item = item as? String else {return nil}
            text = item
        }
        
        guard let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "outlineViewCell"), owner: self) as? NSTableCellView else {return nil}
        cell.textField!.stringValue = text
        return cell
    }
    
    // This method is called last when creating an outlineView
    // We tell whether the row is expandable.
    // --> It is checked if the row is expandable and then it goes back to the how many children it has
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let item = item as? String else {return false}
        if categoryNames.contains(item) {
            return true
        } else {
            return false
        }
    }
}

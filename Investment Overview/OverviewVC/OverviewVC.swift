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
        super.viewDidLoad()
    }
    
    // I do the view setup in the viewWillAppear function since in the viewDidLoad function the detailsVC is still nil and it needs to be accessed by updateView function
    override func viewWillAppear() {
        super.viewWillAppear()
        updateView()
        print(CoreDataHelper.transactions.count)
    }
    
    // Every time the selection in the outline view changes, enable or disable the buttons
    // Also change the details view and give the selected investment / category to the DetailsVC
    func outlineViewSelectionDidChange(_ notification: Notification) {
        // Update the view of the outlineView
        updateButtons()
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
        print("We did get a WC")
        guard let vc = getVC(wc: wc) as? DeleteTransactionVC else {return}
        print("We did get a VC")
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
    
}

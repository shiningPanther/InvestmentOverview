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
        if unitsBoughtHasChanged() {
            let success = updateUnitsBought()
            CoreDataHelper.save()
        }
        
        calculateProfits(investment: selectedInvestment!)
        view.window?.close()
        
    }
    
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
    }
}

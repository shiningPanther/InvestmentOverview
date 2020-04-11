//
//  CalcProfitVC.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 05/06/2019.
//  Copyright © 2019 shiningPanther. All rights reserved.
//

import Cocoa

class CalcProfitVC: NSViewController {

    @IBOutlet weak var nothingFoundLabel: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBOutlet weak var yearTextField: NSTextField!
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.date(from: yearTextField.stringValue)
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
}

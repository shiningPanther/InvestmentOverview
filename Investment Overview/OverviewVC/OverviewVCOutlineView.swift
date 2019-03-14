//
//  OverviewVCOutlineView.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 09.08.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa


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
            return CoreDataHelper.categories.count
        } else if let item = item as? String {
            return CoreDataHelper.investments.filter{$0.category?.name == item}.count
        }
        return 0
    }
    
    
    // This method is called second when creating an outlineView
    // Here, we give each row a unique identifier
    // The function is first called for index = 0, then the next functions are called until index = numberOfChildren
    // item == nil means it's the "root" row of the outline view, which is not visible
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return CoreDataHelper.categories[index].name ?? ""
        } else if let item = item as? String {
            return CoreDataHelper.investments.filter{$0.category?.name == item}[index].name ?? ""
        }
        return ""
    }
    
    // This method is called third when creating an outlineView
    // Set the text for each row and column
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "outlineViewCell"), owner: self) as? NSTableCellView else {return nil}
        cell.textField?.textColor = NSColor.black
        cell.textField?.font = NSFont .systemFont(ofSize: 11)
        
        guard let item = item as? String else {return nil}
        var text = ""
        var totalProfits = 0.0
        
        if let columnIdentifier = tableColumn?.identifier.rawValue, columnIdentifier == "investmentColumn" {
            text = item
            if CoreDataHelper.categories.contains(where: {$0.name == item}) {
                cell.textField?.font = NSFont .boldSystemFont(ofSize: 11)
                let categories = CoreDataHelper.categories.filter({$0.name == item})
                guard categories.count == 1 else {return nil}
                if categories[0].currentValueOfAssets < 0.01 { cell.textField?.textColor = NSColor .systemGray }
            }
            else {
                let investments = CoreDataHelper.investments.filter({$0.name == item})
                guard investments.count == 1 else {return nil}
                if investments[0].currentValueOfAssets < 0.01 { cell.textField?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) }
            }
        }
            
        else if let columnIdentifier = tableColumn?.identifier.rawValue, columnIdentifier == "profitColumn" {
            if CoreDataHelper.categories.contains(where: {$0.name == item}) {
                let categories = CoreDataHelper.categories.filter({$0.name == item})
                guard categories.count == 1 else {return nil}
                totalProfits = categories[0].realizedProfits + categories[0].unrealizedProfits
                text = String(format: "%.2f €", totalProfits)
                cell.textField?.font = NSFont .boldSystemFont(ofSize: 11)
                if totalProfits > 0 {
                    cell.textField?.textColor = NSColor.black
                    if categories[0].currentValueOfAssets < 0.01 { cell.textField?.textColor = NSColor .systemGray }
                }
                if totalProfits < 0 {
                    cell.textField?.textColor = NSColor.red
                    if categories[0].currentValueOfAssets < 0.01 { cell.textField?.textColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1) }
                }
            }
            if CoreDataHelper.investments.contains(where: {$0.name == item}) {
                let investments = CoreDataHelper.investments.filter({$0.name == item})
                guard investments.count == 1 else {return nil}
                totalProfits = investments[0].realizedProfits + investments[0].unrealizedProfits
                text = String(format: "%.2f €", totalProfits)
                if totalProfits > 0 {
                    cell.textField?.textColor = NSColor.black
                    if investments[0].currentValueOfAssets < 0.01 { cell.textField?.textColor = NSColor .systemGray }
                }
                if totalProfits < 0 {
                    cell.textField?.textColor = NSColor.red
                    if investments[0].currentValueOfAssets < 0.01 { cell.textField?.textColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1) }
                }
            }
        }
            
        else if let columnIdentifier = tableColumn?.identifier.rawValue, columnIdentifier == "warningColumn" {
            // if it is a category don't display any warnings...
            if CoreDataHelper.categories.contains(where: {$0.name == item}) {text = ""}
            // if it is an investment a warning can be displayed...
            else if CoreDataHelper.investments.contains(where: {$0.name == item}) {
                let investments = CoreDataHelper.investments.filter({$0.name == item})
                guard investments.count == 1 else {return nil}
                if investments[0].balance == 0 || investments[0].currentPrice != 0.0 {text = ""}
                else {
                    text = "⚠️"
                }
            }
        }
        
        cell.textField!.stringValue = text
        return cell
    }
    
    // This method is called last when creating an outlineView
    // We tell whether the row is expandable.
    // --> It is checked if the row is expandable and then it goes back to the how many children it has
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let item = item as? String else {return false}
        if CoreDataHelper.categories.contains(where: {$0.name == item}) {
            return true
        } else {
            return false
        }
    }
}

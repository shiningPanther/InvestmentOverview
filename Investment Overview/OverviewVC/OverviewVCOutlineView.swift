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
        if CoreDataHelper.categories.contains(where: {$0.name == item}) {
            return true
        } else {
            return false
        }
    }
}

//
//  OverviewVCHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 28.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation
import Cocoa

extension OverviewVC {
    
    func instantiateWCFromStoryboard(identifier: String) -> NSWindowController? {
        guard let wc = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: identifier)) as? NSWindowController else {return nil}
        return wc
    }
    
    func getVCFromWC(wc: NSWindowController) -> NSViewController? {
        guard let vc = wc.contentViewController else {return nil}
        return vc
    }
    
    // Get the selected category and investment in order to give them to other VCs
    // Returns nil for selectedInvestment when a category is selected
    // Returns nil for selectedCategory when an investment is selected
    // Returns nil, nil if nothing is selected
    // It is important that the name of an investment can never be the name of a category!!!
    func getSelectedCategoryAndInvestment() -> (selectedCategory: String?, selectedInvestment: Transaction2?){
        // If something is selected
        if outlineView.selectedRow >= 0 {
            guard let name = outlineView.item(atRow: outlineView.selectedRow) as? String else {return (nil, nil)}
            switch (categoryNames.contains(name)) {
            // true means that a category is selected -> return category name and nil for investment name
            case true:
                return (name, nil)
            // false means that an investment is selected -> return nil for category name and selected investment
            case false:
                let investmentArray = transactions.filter({$0.investmentName == name})
                if investmentArray.count == 1 {
                    return (nil, investmentArray[0])
                } else {
                    return (nil, nil)
                }
            }
        }
            // If nothing is selected
        else {
            return (nil, nil)
        }
    }
    
}


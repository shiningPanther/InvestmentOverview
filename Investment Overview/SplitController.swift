//
//  SplitController.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 15.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa

class SplitController: NSSplitViewController {

    @IBOutlet weak var overviewItem: NSSplitViewItem!
    @IBOutlet weak var detailItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load here the data from core data
        CoreDataHelper.loadTransactions()
        print(CoreDataHelper.investments)
        print(CoreDataHelper.transactions)
        
        // assign here the refereneces between the split view controllers
        guard let overviewVC = overviewItem.viewController as? OverviewVC else {return}
        guard let detailsVC = detailItem.viewController as? DetailsVC else {return}
        overviewVC.detailsVC = detailsVC
        detailsVC.overviewVC = overviewVC
    }
    
}

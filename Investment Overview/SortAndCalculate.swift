//
//  SortAndCalculateFunctions.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 08.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation


class SortAndCalculate {
    
    // Function to calculate the profits
    static func calculateProfits(investment: Investment) {
        investment.balance = 0.0
        
        // go through each transaction
        for transaction in CoreDataHelper.getTransactionsOfInvestment(investment: investment) {
            
            if transaction.type == "Buy" {
                investment.balance += transaction.unitsBought
            }
            else if transaction.type == "Sell" {
                investment.balance -= transaction.unitsBought
            }
        }
    }
}





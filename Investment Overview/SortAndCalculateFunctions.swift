//
//  SortAndCalculateFunctions.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 08.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation


// Function to count the number of categories and investments
public func countInvestmentsAndCategories(transactions: [Transaction2]) -> (categoryNames: [String], investmentNames: [String: [String]]) {
    var categoryNames: [String] = []
    var investmentNames: [String: [String]] = [:]
    
    for transaction in transactions {
        guard let categoryName = transaction.categoryName else{return ([], [:])}
        guard let investmentName = transaction.investmentName else{return ([], [:])}
        
        // 1. Category name does not exist yet
        if !categoryNames.contains(categoryName) {
            categoryNames.append(categoryName)
            investmentNames[categoryName] = [investmentName]
        }
        // 2. Category name exists but it is a new investment Name
        else if !investmentNames[categoryName]!.contains(investmentName) {
            investmentNames[categoryName]!.append(investmentName)
        }
    }
    return (categoryNames,investmentNames)
}


// Function to calculate the profits
public func calculateProfits(transactions: [Transaction2], investmentName: String) -> Double {
    var unitsTotal = 0.0
    let testTransaction = transactions.filter({$0.investmentName == investmentName})
    let unitsBought = testTransaction[0].unitsBought ?? []
    for bought in unitsBought {
        unitsTotal += bought
    }
    return unitsTotal
}



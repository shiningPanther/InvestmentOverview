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
public func calculateProfits(transaction: Transaction2) {
    transaction.currentBalance = 0.0
    guard transaction.date?.count != nil else {return}
    // go through each transaction
    for index in 0..<transaction.date!.count {
        if transaction.type?[index] == "Buy" {
            guard transaction.unitsBought?[index] != nil else {return}
            transaction.currentBalance += transaction.unitsBought![index]
        }
        else if transaction.type?[index] == "Sell" {
            guard transaction.unitsBought?[index] != nil else {return}
            transaction.currentBalance -= transaction.unitsBought![index]
        }
    }
}



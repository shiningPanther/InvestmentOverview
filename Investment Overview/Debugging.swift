//
//  Debugging.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 24/12/2018.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation


class Debugging {
    
    // This function is to delete an entire category with a given name. It makes sure that the category is empty (but does not empty it).
    // It is used for debugging in case something goes wrong
    static func deleteEntireCategory(categoryName: String) {
        let category = CoreDataHelper.categories.filter{$0.name == categoryName}
        guard category.count == 1 else {return}
        let investments = CoreDataHelper.investments.filter{$0.category?.name == categoryName}
        guard investments.count == 0 else {return}
        guard let context = CoreDataHelper.getContext() else {return}
        context.delete(category[0])
    }
    
    // This function deletes an entire investment and also all the transactions contained therein
    static func deleteInvestment(investmentName: String) {
        let investment = CoreDataHelper.investments.filter{$0.name == investmentName}
        guard investment.count == 1 else {return}
        deleteTransactionsOfInvestment(investmentName: investmentName)
        guard let context = CoreDataHelper.getContext() else {return}
        context.delete(investment[0])
    }
    
    // This functions deletes all the transactions contained within an investment
    static func deleteTransactionsOfInvestment(investmentName: String) {
        let transactions = CoreDataHelper.transactions.filter{$0.investment?.name == investmentName}
        guard let context = CoreDataHelper.getContext() else {return}
        for transaction in transactions {
            context.delete(transaction)
        }
    }
    
    // This just moves all the investments into one category
    static func moveInvestmentIntoCategory(categoryName: String) {
        let investments = CoreDataHelper.investments
        let category = CoreDataHelper.categories.filter{$0.name == categoryName}
        for investment in investments {
            investment.category = category[0]
        }
    }
    
    // This function prints the transactions within a particular investment
    static func printTransactionsOfInvestment(investmentName: String) {
        let investment = CoreDataHelper.investments.filter{$0.name == investmentName}
        guard investment.count == 1 else {return}
        for transaction in CoreDataHelper.getTransactionsOfInvestment(investment: investment[0]) {
            print(transaction.remainingBalance)
        }
        print(investment[0].balance)
    }
}

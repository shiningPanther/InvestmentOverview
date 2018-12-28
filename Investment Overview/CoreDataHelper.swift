//
//  CoreDataHelper.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 07.08.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Cocoa


class CoreDataHelper {
    
    // These variables contain all the transactions
    static var categories: [Category] = []
    static var investments: [Investment] = []
    static var transactions: [Transaction] = []
    
    // These variables just contain the names of the categories and investments
    /*static var categoryNames: [String] = []
    static var investmentNames: [String: [String]] = [:]*/
    
    
    static func getContext() -> NSManagedObjectContext? {
        guard let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return nil}
        return context
    }
    
    // This function only has to be run once to load the core data into memory. This is being done when the app loads
    static func loadTransactions() {
        guard let context = getContext() else {return}
        do {
            CoreDataHelper.categories = try context.fetch(Category.fetchRequest()) as [Category]
        } catch {}
        
        do {
            CoreDataHelper.investments = try context.fetch(Investment.fetchRequest()) as [Investment]
        } catch {}

        do {
            CoreDataHelper.transactions = try context.fetch(Transaction.fetchRequest()) as [Transaction]
        } catch {}
        sortTransactions() // This shouldn't be necessary since the arrays are always sorted but I'll do it anyways...
        SortAndCalculate.calculateAllProfits()
    }
    
    // This function just sorts the variables categories, investments and transactions by name, name and date respectively
    static func sortTransactions() {
        categories.sort(by: {$0.name! < $1.name!})
        investments.sort(by: {$0.name! < $1.name!})
        transactions.sort(by: {$0.date! < $1.date!})
    }
    
    
    // I WOULD LIKE TO DELETE THIS ARRAYS AS THEY SHOULD NOT BE NEEDED...
    // update the string names for category and investments, used to populate the tableView
    /*static func updateNames() {
        CoreDataHelper.categoryNames = []
        CoreDataHelper.investmentNames = [:]
        for category in CoreDataHelper.categories {
            CoreDataHelper.categoryNames.append(category.name ?? "")
        }
        for investment in CoreDataHelper.investments {
            CoreDataHelper.investmentNames[investment.category?.name ?? ""]?.append(investment.name ?? "")
        }
    }*/
    
    // returns all of the transactions of an investment
    static func getTransactionsOfInvestment(investment: Investment) -> [Transaction] {
        return transactions.filter({$0.investment == investment})
        // Another possibility would be
        // return investment.transactions?.allObjects as? [Transaction]
    }
    
    static func getBuyTransactionsOfInvestment(investment: Investment) -> [Transaction] {
        return transactions.filter({$0.investment == investment && $0.type == "Buy"})
    }
    
    // just saves the context
    static func save() {
        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
    }
    
    // a function to delete all of the core data - shouldn't be used obviously...
    static func deleteCoreDataBatch() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction2")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let context = getContext() else {return}
        do {
            try context.execute(batchDeleteRequest)
        } catch {}
    }
    
}

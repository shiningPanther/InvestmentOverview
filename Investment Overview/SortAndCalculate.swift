//
//  SortAndCalculateFunctions.swift
//  Investment Overview
//
//  Created by Peter Schmidt on 08.07.18.
//  Copyright © 2018 shiningPanther. All rights reserved.
//

import Foundation


class SortAndCalculate {
    
    static func calculateAllProfits() {
        for investment in CoreDataHelper.investments {
            SortAndCalculate.calculateProfits(investment: investment)
        }
    }
    
    // Function to calculate the profits of a single investment
    static func calculateProfits(investment: Investment) {
        
        investment.balance = 0.0
        investment.realizedProfits = 0.0
        investment.unrealizedProfits = 0.0
        investment.totalProfits = 0.0
        
        let symbol = investment.symbol ?? ""
        let apiName = investment.apiWebsite ?? ""
        getCurrentPrice(investment: investment, symbol: symbol, apiName: apiName)
        
        // go through each transaction in order to calculate the balance and profits
        for transaction in CoreDataHelper.getTransactionsOfInvestment(investment: investment) {
            
            // The remaining balance of each transaction is set to 0 initially
            transaction.remainingBalance = 0.0
            // Also the profit of each transaction is set to 0 initially
            transaction.profit = 0.0

            if transaction.type == "Buy" {
                investment.balance += transaction.unitsBought
                transaction.remainingBalance += transaction.unitsBought
            }
            else if transaction.type == "Sell" {
                investment.balance -= transaction.unitsBought
                transaction.remainingBalance += transaction.unitsBought // Here the remaining balance indidcates how many transactions are units are still to be sold
                guard investment.balance >= 0 else {return} // If this is not fulfilled something has gone wrong...
                // This function calculates the profits made through a sell and assigns the value to the attribut profit of the transaction
                SortAndCalculate.calculateSellProfit(sellTransaction: transaction)
                investment.realizedProfits += transaction.profit
            }
        }
        
        // calculate the unrealized profits
        SortAndCalculate.calculateUnrealizedProfits(investment: investment)
        investment.totalProfits = investment.unrealizedProfits + investment.realizedProfits
    }
    
    // This function calculates the profits made through a sell and assigns it to the attribute profit of the transaction
    static func calculateSellProfit(sellTransaction: Transaction) {
        guard sellTransaction.type == "Sell" else {return}
        
        // Go through each BUY transaction, calculate the profits and reduce its remaining balance
        guard let investment = sellTransaction.investment else {return}
        for buyTransaction in CoreDataHelper.getBuyTransactionsOfInvestment(investment: investment) {
            
            buyTransaction.remainingBalance -= sellTransaction.remainingBalance
            if buyTransaction.remainingBalance < 0 {buyTransaction.remainingBalance = 0}
            let unitsSold = buyTransaction.unitsBought - buyTransaction.remainingBalance
            sellTransaction.remainingBalance -= unitsSold
            let priceDifference = sellTransaction.price - buyTransaction.price
            sellTransaction.profit += unitsSold * priceDifference
            let ratioSold = unitsSold / buyTransaction.unitsBought
            sellTransaction.profit -= buyTransaction.fees * ratioSold
            
            if sellTransaction.remainingBalance == 0 {
                sellTransaction.profit -= sellTransaction.fees
                break
            }
        }
    }
    
    // This is to calculate the unrealized profits. It has to be done after the calculation of the realized profits since these are already deduced
    static func calculateUnrealizedProfits(investment: Investment) {
        
        // Go through each BUY transaction, check how much is still there and see how much profits have been made
        for buyTransaction in CoreDataHelper.getBuyTransactionsOfInvestment(investment: investment) {
            if buyTransaction.remainingBalance != 0 {
                let priceDifference = investment.currentPrice - buyTransaction.price
                let profit = priceDifference * buyTransaction.remainingBalance
                buyTransaction.profit = profit
                investment.unrealizedProfits += profit
            }
        }
    }
    
    
    static func getCurrentPrice(investment: Investment, symbol: String, apiName: String) {
        
        guard ViewHelper.apiNames.contains(apiName) else {return}
        
        switch apiName {
            
        case "Cryptocompare":
            let urlString = String(format: "https://min-api.cryptocompare.com/data/price?fsym=%@&tsyms=EUR", symbol)
            print(urlString)
            guard let url = URL(string: urlString) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else{
                    print("An error occured")
                    print(error!)
                    return
                }
                guard data != nil else {return}
                // Make a json object out of the returned data
                let json = JSON(data!)
                let price = json["EUR"].double ?? 0.0
                print(json["EUR"].double ?? "Not defined")
                investment.currentPrice = price
                investment.lastUpdate = Date()
                }.resume()
            
            
        default:
            print("We are in the default case")
            return
        }
    }
}





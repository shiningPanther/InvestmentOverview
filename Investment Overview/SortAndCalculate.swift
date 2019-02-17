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
        for category in CoreDataHelper.categories {
            SortAndCalculate.calculateProfits(category: category)
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
        SortAndCalculate.getCurrentPrice(investment: investment, symbol: symbol, apiName: apiName)
        
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
                // This function calculates the profits made through a sell and assigns the value to the attribute 'profit' of the transaction
                SortAndCalculate.calculateSellProfit(sellTransaction: transaction)
                investment.realizedProfits += transaction.profit
            }
        }
        
        // We can now easily calculate the invested money, since the remaining balance of all transactions is known - The invested money is just the sum of all buy transactions that we still hold (plus fees)
        SortAndCalculate.calculateInvestedMoney(investment: investment)
        
        SortAndCalculate.calculateCurrentValueOfAssets(investment: investment)
        
        // calculate the unrealized profits
        SortAndCalculate.calculateUnrealizedProfits(investment: investment)
        investment.totalProfits = investment.unrealizedProfits + investment.realizedProfits
    }
    
    static func calculateCurrentValueOfAssets (investment: Investment) {
        var price = investment.currentPrice
        if price == 0 {
            price = CoreDataHelper.getTransactionsOfInvestment(investment: investment).last?.price ?? 0.0
        }
        investment.currentValueOfAssets = price * investment.balance }
    
    
    // Function to calculate the profits of a category
    static func calculateProfits(category: Category) {
        
        category.investedMoney = 0.0
        category.currentValueOfAssets = 0.0
        category.realizedProfits = 0.0
        category.unrealizedProfits = 0.0
        
        for investment in CoreDataHelper.getInvestmentsOfCategory(category: category) {
            category.investedMoney += investment.investedMoney
            category.currentValueOfAssets += investment.currentValueOfAssets
            category.realizedProfits += investment.realizedProfits
            category.unrealizedProfits += investment.unrealizedProfits
        }
    }
    
    // Function to calculate the total profits
    static func calculateTotalProfits() -> (Double, Double, Double, Double) {
        var investedMoney = 0.0
        var currentValueOfAssets = 0.0
        var realizedProfits = 0.0
        var unrealizedProfits = 0.0
        
        for category in CoreDataHelper.categories {
            investedMoney += category.investedMoney
            currentValueOfAssets += category.currentValueOfAssets
            realizedProfits += category.realizedProfits
            unrealizedProfits += category.unrealizedProfits
        }
        return (investedMoney, currentValueOfAssets, realizedProfits, unrealizedProfits)
    }
    
    // This function calculates the money that we have invested. It is just the the sum of all buy transactions that we still hold (remaining balance), plus fees
    static func calculateInvestedMoney(investment: Investment) {
        
        investment.investedMoney = 0
        
        // Go through all buyTransactions and check their remaining balance
        for buyTransaction in CoreDataHelper.getBuyTransactionsOfInvestment(investment: investment) {
            // If the remaining balance is 0 (i.e. we sold that already then don't do anything...)
            if buyTransaction.remainingBalance == 0 {continue}
            investment.investedMoney += buyTransaction.remainingBalance / buyTransaction.unitsBought * (buyTransaction.unitsBought * buyTransaction.price + buyTransaction.fees)
        }
    }
    
    // This function calculates the profits made through a sell and assigns it to the attribute profit of the transaction
    static func calculateSellProfit(sellTransaction: Transaction) {
        guard sellTransaction.type == "Sell" else {return}
        
        // Go through each BUY transaction, calculate the profits and reduce its remaining balance
        guard let investment = sellTransaction.investment else {return}
        for buyTransaction in CoreDataHelper.getBuyTransactionsOfInvestment(investment: investment) {
            
            var unitsSold = sellTransaction.remainingBalance
            if unitsSold > buyTransaction.remainingBalance {unitsSold = buyTransaction.remainingBalance}
            buyTransaction.remainingBalance -= unitsSold
            sellTransaction.remainingBalance -= unitsSold
            let priceDifference = sellTransaction.price - buyTransaction.price
            sellTransaction.profit += unitsSold * priceDifference
            let ratioSold = unitsSold / buyTransaction.unitsBought
            sellTransaction.profit -= buyTransaction.fees * ratioSold
            
            if sellTransaction.remainingBalance == 0.0 {
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
                // priceDifference is either the "real" price difference or if no current price is available we assume the price of the last transaction to be the current price
                var priceDifference = 0.0
                if investment.currentPrice != 0 {
                    priceDifference = investment.currentPrice - buyTransaction.price }
                else {
                    let price = CoreDataHelper.getTransactionsOfInvestment(investment: investment).last?.price ?? buyTransaction.price
                    priceDifference = price - buyTransaction.price }
                let ratioSold = buyTransaction.remainingBalance/buyTransaction.unitsBought
                let profit = priceDifference * buyTransaction.remainingBalance - buyTransaction.fees * ratioSold
                buyTransaction.profit = profit
                investment.unrealizedProfits += profit }}}
    
    
    static func getCurrentPrice(investment: Investment, symbol: String, apiName: String) {
        
        guard ViewHelper.apiNames.contains(apiName) else {return}
        
        switch apiName {
            
        case "CryptoCompare":
            let urlString = String(format: "https://min-api.cryptocompare.com/data/price?fsym=%@&tsyms=EUR", symbol)
            // print(urlString)
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
                // print(json["EUR"].double ?? "Not defined")
                investment.currentPrice = price
                investment.lastUpdate = Date()
            }.resume()
            
        case "IEX":
            let urlString = String(format: "https://api.iextrading.com/1.0/stock/%@/price", symbol)
            // print(urlString)
            guard let url = URL(string: urlString) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else{
                    print("An error occured")
                    print(error!)
                    return
                }
                guard data != nil else {return}
                let priceUsdString = String(data: data!, encoding: .utf8)
                let priceUsd = Double(priceUsdString!) ?? 0.0
                investment.currentPriceUSD = priceUsd
            }.resume()
            
            // Get the conversion rate to EUR
            let urlStringConversion = String(format: "https://api.exchangeratesapi.io/latest")
            guard let urlConversion = URL(string: urlStringConversion) else {return}
            URLSession.shared.dataTask(with: urlConversion) { (data, response, error) in
                guard error == nil else {
                    print("An error occured in the conversion rates")
                    print(error!)
                    return
                }
                guard data != nil else {return}
                // Make a json object out of the returned data
                let json = JSON(data!)
                let conversionRate = json["rates"]["USD"].double ?? 0.0
                investment.currentPrice = investment.currentPriceUSD / conversionRate
                investment.lastUpdate = Date()
            }.resume()
            
            
        default:
            print("We are in the default case")
            return
        }
    }
}





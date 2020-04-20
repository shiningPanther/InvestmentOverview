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
            else if transaction.type == "Airdrop" {
                investment.balance += transaction.unitsBought
                transaction.remainingBalance += transaction.unitsBought
            }
            else if transaction.type == "Sell" {
                investment.balance -= transaction.unitsBought
                transaction.remainingBalance += transaction.unitsBought // Here the remaining balance indidcates how many transactions are units are still to be sold
                // guard investment.balance >= 0 else {return} // If this is not fulfilled something has gone wrong...
                // This function calculates the profits made through a sell and assigns the value to the attribute 'profit' of the transaction
                SortAndCalculate.calculateSellProfit(sellTransaction: transaction)
                investment.realizedProfits += transaction.profit
            }
            else if transaction.type == "Dividends" {
                transaction.profit = transaction.unitsBought * transaction.price
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
        let price = investment.currentPrice
        // Here, if no price is available I take the price of the last transaction. But I prefer to set the price to 0 if no price is available...
        /*if price == 0 {
            price = CoreDataHelper.getTransactionsOfInvestment(investment: investment).last?.price ?? 0.0
        }*/
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
                /*if investment.currentPrice != 0 {
                    priceDifference = investment.currentPrice - buyTransaction.price }
                else {
                    let price = CoreDataHelper.getTransactionsOfInvestment(investment: investment).last?.price ?? buyTransaction.price
                    priceDifference = price - buyTransaction.price } */
                // Here, I calculate it differently: If no price is available we take the price to be 0...
                priceDifference = investment.currentPrice - buyTransaction.price
                let ratioSold = buyTransaction.remainingBalance/buyTransaction.unitsBought
                let profit = priceDifference * buyTransaction.remainingBalance - buyTransaction.fees * ratioSold
                buyTransaction.profit = profit
                investment.unrealizedProfits += profit }}}
    
    static func resetLastSuccessfulUpdate() {
        for investment in CoreDataHelper.investments {
            investment.lastSuccessfulUpdate = Date(timeIntervalSince1970: 0)
        }
    }
    
    static func getCurrentPrice(investment: Investment, symbol: String, apiName: String) {
        
        // USD-EUR conversion rate - update from time to time
        // Current rate from 2020/04/20
        let usdRate = 0.92
        
        guard ViewHelper.apiNames.contains(apiName) else {return}
        if investment.lastUpdate == nil {investment.lastUpdate = Date(timeIntervalSince1970: 0)}
        if investment.lastSuccessfulUpdate == nil {investment.lastSuccessfulUpdate = Date(timeIntervalSince1970: 0)}
        
        switch apiName {
            
        case "CryptoCompare":
            // If an API call has been made less than 10 minutes ago, we do not make another call
            let secondsSinceLastCall = Date().timeIntervalSince(investment.lastUpdate!)
            if secondsSinceLastCall < 600
            {return}
            
            print(String(format: "API call to CryptoCompare - %@", investment.name ?? ""))
            let urlString = String(format: "https://min-api.cryptocompare.com/data/price?fsym=%@&tsyms=EUR", symbol)
            // print(urlString)
            guard let url = URL(string: urlString) else {return}
            
            investment.lastUpdate = Date()
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else{
                    print("An error occured")
                    print(error!)
                    return
                }
                guard data != nil else {return}
                // Make a json object out of the returned data
                let json = JSON(data!)
                let price = json["EUR"].doubleValue
                guard price > 0 else {return}
                investment.currentPrice = price
                investment.lastSuccessfulUpdate = Date()
            }.resume()
            
        case "Rapidapi":
            // We implement these checks to make sure the APIs are not called too often
            // Rapidapi only allows 5 calls per minute
            
            // First, if a price has been updated today, we don't update it again
            let calendar = Calendar.current
            if calendar.isDateInToday(investment.lastSuccessfulUpdate!) {return}
            
            // Second, if an API call has been made less than a few minutes ago, we do not make another call
            let secondsSinceLastCall = Date().timeIntervalSince(investment.lastUpdate!)
            if secondsSinceLastCall < 90 {return}
            
            print(String(format: "API call to Rapidapi - %@", investment.name ?? ""))
            let urlString = String(format: "https://alpha-vantage.p.rapidapi.com/query")
            guard var components = URLComponents(string: urlString) else {return}
            components.queryItems = [
                URLQueryItem(name: "symbol", value: investment.symbol ?? ""),
                URLQueryItem(name: "function", value: "GLOBAL_QUOTE")
            ]
            var request = URLRequest(url: components.url!)
            request.addValue("75668d9d74msh8eabfb4bd3bebc1p182e9fjsn392037530a32", forHTTPHeaderField: "x-rapidapi-key")
//            print(request.description)
            
            investment.lastUpdate = Date()
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("An error occured when accessing DB")
                    print(error!)
                    return
                }
                guard data != nil else {
                    print("We have no data")
                    return
                }
                let json = JSON(data!)
//                print(json["Global Quote"])
                let price = json["Global Quote"]["05. price"].doubleValue
                guard price > 0 else {return}
                if String(investment.symbol!.suffix(2)) == "DE" {investment.currentPrice = price}
                else {investment.currentPrice = price * usdRate}
                // These are some special cases, where the API returns the Dollar price but shouldn't
                if investment.symbol! == "DBXW.DE" {investment.currentPrice = price * usdRate}
//                let dateString = json["Global Quote"]["07. latest trading day"].stringValue
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let date = dateFormatter.date(from: dateString)
//                if date != nil {investment.lastUpdate = date}
                investment.lastSuccessfulUpdate = Date()
            }.resume()
            
        default:
            print(String(format: "We are in the default case - %@", investment.name ?? ""))
            return
        }
    }
}





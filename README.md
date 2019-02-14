#### InvestmentOverview


## Overview
An application for macOS (written in Swift) that lists and categorises different kinds of investments (stocks, ETFs, cryptos, etc) and calculates the profits of each one of them.

I deployed this application for two main reasons:

1. I noticed that my broker did not keep proper track of my gains & losses so that my tax declaration was a mess and took me forever.
2. Trades on cryptocurrencies were scattered over 10s of different exchanges and it was a nightmare to keep track of them.

This application is a place to keep a detailed overview over gains & losses for different categories of investments.


## Features
Transactions have to be added manually with the following parameters: Name of the investment (has to be unique - e.g. Apple or Bitcoin), investment symbol (e.g. AAPL or BTC) or ISIN, category, number of units bought, price per unit, fees, exchange, date & time.

The real-time price of the investment is then queried from the following APIs:

* US stocks: [IEX](https://iextrading.com/developer/)
* Stocks, securities, etc traded in Frankfurt, Germany: [Deutsche Börse Group](https://console.developer.deutsche-boerse.com)
* Cryptocurrencies: [CryptoCompare](https://min-api.cryptocompare.com)




//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Danish Khalid on 11/09/2019.
//  Copyright © 2019 Danish Khalid. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func updateCoinPrice(price: Double)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://api.nomics.com/v1/currencies/ticker?&ids=BTC&interval=1h"
    let apiKey = "3c960664e179f99aba40e82918f80de9"
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)&key=\(apiKey)&convert=\(currency)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    self.delegate?.updateCoinPrice(price: self.parseJSON(safeData)!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData: [CoinData] = try decoder.decode([CoinData].self, from: data)
            let lastPrice = Double(decodedData[0].price)!
            return lastPrice
        } catch {
            print(error)
            return nil
        }
    }
    
}

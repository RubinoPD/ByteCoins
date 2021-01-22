

import Foundation

// By convention, Swift protocols are usually written in the file that has the class/struc which will call the delegate methods, i.e. the CoinManager.

protocol CoinManagerDelegate {
    
    //Create the method stubs without implementation in the protocol.
    //It's usually a good idea to also pass along a reference to the current class.
    //e.g. func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "API KEY GOES HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        // Use String concatination to add selected currency at the end of the baseURL along with the URL key.
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        // Use optional binding to unwrap the URL that is created from the urlString
        if let url = URL(string: urlString) {
            
            // Create a new URLSession object with default configuration
            let session = URLSession(configuration: .default)
            
            // Create a new data task for the URLSession
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        // Round the price to 2 decimal places.
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        // Call the delegate method in the delegate (ViewControler) and pass along the necessary data.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                    
                }
            }
            
            // Start tas to fetch data from bitoin average's server.
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        // Create JSON decoder
        let decoder = JSONDecoder()
        do {
            
            // Try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            // Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            
            // Catch any errors
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}



import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9C4C396F-A800-426E-BC0E-20031EA64779"
    
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
                print(error!)
                return
                }
                
                if let safeData = data {
                    let bitcoinPrice = self.parseJSON(safeData)
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
            
            // Catch any print errors
            print(error)
            return nil
        }
    }
    
}

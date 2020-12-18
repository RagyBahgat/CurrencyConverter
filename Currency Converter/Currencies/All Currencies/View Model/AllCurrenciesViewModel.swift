//
//  AllCurrenciesViewModel.swift
//  Currency Converter
//
//  Created by Ragy Bahgat on 12/18/20.
//

import Foundation

class AllCurrenciesViewModel {
    
    private var currencyModels = [CurrencyModel]()
    private var cities = [String]()
    private var currenciesDictionary = [String: Double]()
    
    var didRecievedCurrecies: (() -> ())?
    
    func fetchCurrencies(baseCurrency: String) {
        let urlString = "http://data.fixer.io/api/latest?access_key=7648d832347f1598412d4ca8d353f0a1&base=\(baseCurrency)"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            if let d = data {
                if let value = String(data: d, encoding: String.Encoding.ascii) {
                    if let jsonData = value.data(using: String.Encoding.utf8) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                            var jsonString = String(describing: json["rates"]!)
                            jsonString.removeFirst()
                            jsonString.removeLast()
                            let arr = String(describing: jsonString).split(separator: ";")
                            var models = [CurrencyModel]()
                            var dictionary = [String: Double]()
                            for i in arr {
                                print(i)
                                let ar = i.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).split(separator: "=")
                                if ar.count == 2 {
                                    let key = ar[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                    var rate = ar[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                    rate = rate.trimmingCharacters(in: CharacterSet.init(charactersIn: "\"\""))
                                    dictionary[key] = Double(rate)!
                                    models.append(CurrencyModel(city: key, currency: Double(rate)!))
                                }
                            }
                            self.recievedCurrencies(currencyModels: models, currencyDictionary: dictionary)
                        } catch {
                            NSLog("ERROR \(error.localizedDescription)")
                        }
                    }
                }
                
            }
        }.resume()
    }
    
    func getCurrenciesCount() -> Int {
        return currencyModels.count
    }
    
    func getCurrencies() -> [CurrencyModel] {
        return currencyModels
    }
    
    func getCities() -> [String] {
        return cities
    }
    
    func getCurrencyDictionary() -> [String: Double] {
        return currenciesDictionary
    }
    
    private func recievedCurrencies(currencyModels: [CurrencyModel], currencyDictionary: [String: Double]) {
        self.currencyModels = currencyModels
        currenciesDictionary = currencyDictionary
        currencyModels.forEach{ cities.append($0.city) }
        didRecievedCurrecies?()
    }
}

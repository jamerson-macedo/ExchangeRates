//
//  CurrencySymbolsDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol CurrencySymbolsDataProviderDelegate : DataProviderManagerDelegate{
    func success(model:[CurrencySymbolModel])
}
class CurrencySymbolsDataProvider : DataProviderManager<CurrencySymbolsDataProviderDelegate, [CurrencySymbolModel]>{
    private let currencyStore : CurrencyStore
    init(currencyStore: CurrencyStore = CurrencyStore()) {
        self.currencyStore = currencyStore
    }
    func fetchSymbols(){
        Task.init{
            do {
                let model = try await currencyStore.fetchSymbols()
                delegate?.success(model: model.map({(key,value) -> CurrencySymbolModel in
                    return CurrencySymbolModel(symbol: key, fullname: value)
                    
                }))
            }catch{
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}

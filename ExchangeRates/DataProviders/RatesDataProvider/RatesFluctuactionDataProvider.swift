//
//  RatesFluctuactionDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol RatesFluctuactionDataProviderDelegate:DataProviderManagerDelegate{
    func success(model:RateFluctuationObject)
}

class RatesFluctuactionDataProvider : DataProviderManager<RatesFluctuactionDataProviderDelegate, RateFluctuationObject>{
    private let ratesStore : RateStore
    init(ratesStore: RateStore = RateStore()) {
        self.ratesStore = ratesStore
    }
    func fetchFluctuation(by base:String,from symbols :[String],startDate :String, endDate :String){
        Task.init{
            do {
                let model = try await ratesStore.fetchFluctuation(by: base, from: symbols, startDate: startDate, endDate: endDate)
                delegate?.success(model: model)
            }catch{
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}

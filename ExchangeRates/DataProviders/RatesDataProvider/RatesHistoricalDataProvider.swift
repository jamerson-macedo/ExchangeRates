//
//  RatesHistoricalDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol RatesHistoricalDataProviderDelegate:DataProviderManagerDelegate{
    func success(model:RatesHistoricalObject)
}

class RatesHistoricalnDataProvider : DataProviderManager<RatesHistoricalDataProviderDelegate, RatesHistoricalObject>{
    private let ratesStore : RateStore
    init(ratesStore: RateStore = RateStore()) {
        self.ratesStore = ratesStore
    }
    func fetchTimeseries(by base:String,from symbols :[String],startDate :String, endDate :String){
        Task.init{
            do {
                let model = try await ratesStore.fetchTimeseries(by: base, from: symbols, startDate: startDate, endDate: endDate)
                delegate?.success(model: model)
            }catch{
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}

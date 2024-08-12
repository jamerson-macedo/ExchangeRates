//
//  RatesHistoricalDataProvider.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol RatesHistoricalDataProviderDelegate:DataProviderManagerDelegate{
    func success(model:[RateHistoricalModel])
}

class RatesHistoricalnDataProvider : DataProviderManager<RatesHistoricalDataProviderDelegate, [RateHistoricalModel]>{
    private let ratesStore : RateStore
    init(ratesStore: RateStore = RateStore()) {
        self.ratesStore = ratesStore
    }
    func fetchTimeseries(by base:String,from symbols :String,startDate :String, endDate :String){
        Task.init{
            do {
                let model = try await ratesStore.fetchTimeseries(by: base, from: symbols, startDate: startDate, endDate: endDate)
                
                
                delegate?.success(model: model.flatMap({ (period,rates) -> [RateHistoricalModel] in
                    return rates.map{
                        RateHistoricalModel(symbol: $0, period: period.toDate(), endRate: $1)
                    }
                }))
            }catch{
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}

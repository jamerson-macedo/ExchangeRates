//
//  RateStore.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 30/07/24.
//

import Foundation
protocol RateStoreProtocol{
    func fetchFluctuation(by base:String,from symbols :[String],startDate :String, endDate :String) async throws -> RateFluctuationObject
    func fetchTimeseries(by base:String,from symbols :[String],startDate :String, endDate :String) async throws ->RatesHistoricalObject
}


class RateStore :BaseStore, RateStoreProtocol {
    func fetchFluctuation(by base: String, from symbols: [String], startDate: String, endDate: String) async throws -> RateFluctuationObject {
        guard let urlRequest = try RatesRouter.fluctuation(base: base, symbols: symbols, startDate: startDate, endDate: endDate).asUrlRequest() else {throw error}
        
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        guard let rates = try RateResult<RateFluctuationObject>(data: data, response: response).rates
        else {throw error}
        return rates
    }
    
    func fetchTimeseries(by base: String, from symbols: [String], startDate: String, endDate: String) async throws -> RatesHistoricalObject {
        guard let urlrequest = try RatesRouter.timeSeries(base: base, symbols: symbols, startDate: startDate, endDate: endDate).asUrlRequest() else {throw error}
        let (data,response) = try await URLSession.shared.data(for: urlrequest)
        guard let rates = try RateResult<RatesHistoricalObject>(data: data, response: response).rates
        else {throw error}
        return rates
    }
   
    
    
}

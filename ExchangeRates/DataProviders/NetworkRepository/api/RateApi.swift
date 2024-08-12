//
//  RateApi.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 29/07/24.
//

import Foundation
enum HttpMethod : String{
    case get = "GET"
}
struct RateApi {
    static let baseUrl = "https://api.apilayer.com/exchangerates_data/"
    static let apiKey = "j9QTQIUUngZ0ETfDT6oMJM8c2OkdM7QE"
    static let fluctuation = "fluctuation"
    static let symbols = "symbols"
    static let timeseries = "timeseries"
}

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
    static let apiKey = "89ldRRCia2Uzz4oiCdXW09d2vC84eNbL"
    static let fluctuation = "fluctuation"
    static let symbols = "symbols"
    static let timeseries = "timeseries"
}

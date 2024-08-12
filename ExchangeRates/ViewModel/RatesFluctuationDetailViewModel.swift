//
//  RatesFluctuationDetailViewModel.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 07/08/24.
//

import Foundation
import SwiftUI
extension RatesFluctuationDetailView {
    @MainActor class ViewModel :ObservableObject, RatesFluctuactionDataProviderDelegate,RatesHistoricalDataProviderDelegate {
        
        
        @Published var ratesFluctuation = [RateFluctuationModel]()
        
        @Published var ratesHistorical = [RateHistoricalModel]()
        
        @Published var timeRange = TimeRangeEnum.today
        
        @Published var baseCurrency:String?
        
        @Published var rateFluctuation:RateFluctuationModel?
        
        private var fluctuationDataProvider : RatesFluctuactionDataProvider?
        
        private var historicalDataProvider : RatesHistoricalnDataProvider?
        
        
        var title : String {
            return "\(baseCurrency ?? "") a \(symbol)"
        }
        var symbol : String{
            return rateFluctuation?.symbol ?? ""
        }
        
        var endRate :Double{
            return rateFluctuation?.endRate ?? 0.0
        }
        var changePct : Double{
            return rateFluctuation?.changePct ?? 0.0
        }
        var change :Double {
            return rateFluctuation?.change ?? 0.0
        }
        
        var xAxisStride : Calendar.Component {
            switch timeRange {
            case .today:
                return .hour
            case .thisWeek:
                return .day
            case .thisMonth:
                return .day
            case .thisSemester:
                return .month
            case .thisYear:
                return .month
            }
        }
        
        var xAxisStrideCount : Int{
            switch timeRange {
            case .today:
                return 6
            case .thisWeek:
                return 2
            case .thisMonth:
                return 6
            case .thisSemester:
                return 2
            case .thisYear:
                return 3
            }
        }
        
        var yAxisMin:Double{
            let min = ratesHistorical.map{$0.endRate}.min() ?? 0.0
            return (min - (min * 0.02))
        }
        var yAxisMax:Double{
            let max = ratesHistorical.map{$0.endRate}.max() ?? 0.0
            return (max + (max * 0.02))
        }
        var  hasRates:Bool{
            return ratesHistorical.filter { $0.endRate > 0}.count > 0
        }
        var changeDescription : String{
            switch timeRange {
            case .today:
                return "\(change.formater(decimalPlaces: 4, with: true)) 1 dia"
            case .thisWeek:
                return "\(change.formater(decimalPlaces: 4, with: true)) 7 dias"
            case .thisMonth:
                return "\(change.formater(decimalPlaces: 4, with: true)) 1 mês"
            case .thisSemester:
                return "\(change.formater(decimalPlaces: 4, with: true)) 6 meses"
            case .thisYear:
                return "\(change.formater(decimalPlaces: 4, with: true)) 1 ano"
                
            }
        }
        
       
        
        init(fluctuationProvider : RatesFluctuactionDataProvider = RatesFluctuactionDataProvider(),
             historicalDataProvider : RatesHistoricalnDataProvider = RatesHistoricalnDataProvider()
        ){
            self.fluctuationDataProvider = fluctuationProvider
            self.historicalDataProvider = historicalDataProvider
            
            self.fluctuationDataProvider?.delegate = self
            self.historicalDataProvider?.delegate = self
        }
        func xAxislabelFormatSTyle(for date:Date)->String{
            switch timeRange {
            case .today:
                return date.formatter(dateFormat: "HH:mm")
            case .thisWeek, .thisMonth:
                return date.formatter(dateFormat: "dd, MMM")
            case .thisSemester:
                return date.formatter(dateFormat: "MMM")
            case .thisYear:
                return date.formatter(dateFormat: "MMM, YYYY")
            }
        }
        
        func startStateView(baseCurrency : String,rateFluctuation :RateFluctuationModel, timeRange :TimeRangeEnum){
            self.baseCurrency = baseCurrency
            self.rateFluctuation = rateFluctuation
            doFetchData(from:timeRange)
        
        }
        func doFetchData(from timeRange :TimeRangeEnum){
            ratesFluctuation.removeAll()
            ratesHistorical.removeAll()
            withAnimation{
                self.timeRange = timeRange
            }
            doFetchRatesFluctuation()
            doFetchRatesHistorical(by: symbol)
        }
        func doComparation(with rateFluctuation:RateFluctuationModel){
            self.rateFluctuation = rateFluctuation
            doFetchRatesHistorical(by: rateFluctuation.symbol)
        }
        func doFilter(by currency :String){
            if let rateFluctuation = ratesFluctuation.filter({$0.symbol == currency }).first{
                self.rateFluctuation = rateFluctuation
                doFetchRatesHistorical(by: rateFluctuation.symbol)
            }
        }
        
        private func doFetchRatesFluctuation(){
            if let baseCurrency {
                let startDate = timeRange.date.toString()
                let endDate = Date().toString()
                fluctuationDataProvider?.fetchFluctuation(by: baseCurrency, from: [], startDate: startDate, endDate: endDate)
            }
        }
        
        private func doFetchRatesHistorical(by currency :String){
            if let baseCurrency {
                let startDate = timeRange.date.toString()
                let endDate = Date().toString()
                
                historicalDataProvider?.fetchTimeseries(by: baseCurrency, from: currency, startDate: startDate, endDate: endDate)
            }
        }
        
        nonisolated func success(model: [RateHistoricalModel]) {
            DispatchQueue.main.async {
                self.ratesHistorical = model.sorted{$0.period > $1.period}
            }
            
        }
        
        nonisolated func success(model: [RateFluctuationModel]) {
            DispatchQueue.main.async {
                self.rateFluctuation = model.filter({$0.symbol == self.symbol}).first
                self.ratesFluctuation = model.filter({$0.symbol != self.baseCurrency}).sorted{
                    $0.symbol < $1.symbol
                }
            }
            
        }
    }
}

//
//  RatesFluctuationViewModel.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 02/08/24.
//

import Foundation
import SwiftUI

extension RatesFluctuationView {
    @MainActor class ViewModel : ObservableObject,RatesFluctuactionDataProviderDelegate{
        
        @Published var ratesFluctuation = [RateFluctuationModel]()
        @Published var timeRange = TimeRangeEnum.today
        @Published var baseCurrency = "BRL"
        @Published var currencies = [String]()
        private let dataProvider : RatesFluctuactionDataProvider?
        
        
        init( dataProvider: RatesFluctuactionDataProvider = RatesFluctuactionDataProvider()) {
            
            self.dataProvider = dataProvider
            self.dataProvider?.delegate = self
            
        }
        func doFetchRatesFluctuation(timeRange: TimeRangeEnum){
            withAnimation {
                self.timeRange = timeRange
            }
            let startDate = timeRange.date.toString()
            let endDatte = Date().toString()
            dataProvider?.fetchFluctuation(by: baseCurrency, from: currencies, startDate: startDate, endDate: endDatte)
        }
        nonisolated func success(model: [RateFluctuationModel]) {
            DispatchQueue.main.async {
                withAnimation {
                    self.ratesFluctuation = model.sorted{
                        $0.symbol < $1.symbol
                    }
                }
            }
        }
        
  
       
     
    }
}

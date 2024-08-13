//
//  RatesFluctuationViewModel.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 02/08/24.
//

import Foundation
import SwiftUI
import Combine
extension RatesFluctuationView {
    @MainActor class ViewModel : ObservableObject{
        enum ViewState {
            case start
            case loading
            case success
            case failure(String)
        }
        // lista com dados
        @Published var ratesFluctuation = [RateFluctuationModel]()
        @Published var searchResults = [RateFluctuationModel]()
        // começando o os dias do diltro
        @Published var timeRange = TimeRangeEnum.today
        // iniando a primeira moeda
        @Published var baseCurrency = "BRL"
        
        @Published var currencies = [String]()
        @Published var currentState : ViewState = .start
        // para quando cancelar nao bugar
        private var cancelables = Set<AnyCancellable>()
        
        private let dataProvider : RatesFluctuactionDataProvider?
        
        
        init( dataProvider: RatesFluctuactionDataProvider = RatesFluctuactionDataProvider()) {
            self.dataProvider = dataProvider
        }
        func doFetchRatesFluctuation(timeRange: TimeRangeEnum){
            currentState = .loading
            withAnimation {
                self.timeRange = timeRange
            }
            let startDate = timeRange.date.toString()
            let endDatte = Date().toString()
            dataProvider?.fetchFluctuation(by: baseCurrency, from: currencies, startDate: startDate, endDate: endDatte).receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.currentState = .success
                    case .failure(let message):
                        self.currentState = .failure(message.localizedDescription)
                    }
                }, receiveValue: { rates in
                    self.ratesFluctuation = rates.sorted{$0.symbol < $1.symbol}
                    self.searchResults = self.ratesFluctuation
                    
                }).store(in: &cancelables) // ao inves de usar o cancel manualmente ele ja tira da memoria aqui
            
        }
    }
}

//
//  RatesFluctuationView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 31/07/24.
//

import SwiftUI



struct RatesFluctuationView: View {
    @StateObject var viewmodel = ViewModel()
    @State private var searchText = ""
    
    @State private var isPresented = false
    @State private var filtersPresented = false
    @State private var  viewDidLoad = true
    var searchResult : [RateFluctuationModel]{
        if searchText.isEmpty{
            return viewmodel.ratesFluctuation
        }else {
            return viewmodel.ratesFluctuation.filter{ element in
                element.symbol.contains(searchText.uppercased()) ||
                element.change.formater(decimalPlaces:4).contains(searchText.uppercased()) ||
                element.changePct.toPercentage().contains(searchText.uppercased()) ||
                element.endRate.formater(decimalPlaces: 2).contains(searchText.uppercased())
            }
        }
    }
    var body: some View {
        NavigationView{
            VStack{
                CurrencyTimeFilterView
                ratesFluctuationListView
                
            }
                        .searchable(text: $searchText)
            .navigationTitle("Conversão de moedas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button(action: {
                    filtersPresented.toggle()
                }, label: {
                    Image(systemName: "slider.horizontal.3")
                })
            }.fullScreenCover(isPresented: $filtersPresented){
                CurrencySelectionFilterView(delegate:self)
            }

        }.onAppear{
            if viewDidLoad{
                viewDidLoad = false
                viewmodel.doFetchRatesFluctuation(timeRange: .today)
            }
        }
    }
    private var CurrencyTimeFilterView : some View{
        HStack(alignment:.center,spacing: 16){
            Button(action: {
                isPresented.toggle()

            }, label: {
                Text(viewmodel.baseCurrency).font(.system(size: 14,weight: .bold)).padding(.init(top: 4, leading: 9, bottom: 4, trailing: 8))
                    .foregroundColor(.white)
                    .overlay{
                        RoundedRectangle(cornerRadius: 8).stroke(.white,lineWidth: 1)
                    }
            }
            )
            .fullScreenCover(isPresented:$isPresented){
                BaseCurrencyFilterView(delegate: self)
            }
            .background(Color(UIColor.lightGray))
                .cornerRadius(8)
            
            Button(action: {
                viewmodel.doFetchRatesFluctuation(timeRange: .today)
            }, label: {
                Text("1 Dia").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .today ? .blue : .gray).underline(viewmodel.timeRange == .today)
                
            }
            )
            Button(action: {
                viewmodel.doFetchRatesFluctuation(timeRange: .thisWeek)
            }, label: {
                Text("7 Dias").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .thisWeek ? .blue : .gray).underline(viewmodel.timeRange == .thisWeek)
                
            }
            )
            Button(action: {
                viewmodel.doFetchRatesFluctuation(timeRange: .thisMonth)
            }, label: {
                Text("1 Mês").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .thisMonth ? .blue : .gray).underline(viewmodel.timeRange == .thisMonth)
                
            }
            )
            Button(action: {
                viewmodel.doFetchRatesFluctuation(timeRange: .thisSemester)
            }, label: {
                Text("6 Meses").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .thisSemester ? .blue : .gray).underline(viewmodel.timeRange == .thisSemester)
                
            }
            )
            Button(action: {
                viewmodel.doFetchRatesFluctuation(timeRange: .thisYear)
            }, label: {
                Text("1 Ano").font(.system(size: 14,weight: .bold))
                    .foregroundColor(viewmodel.timeRange == .thisYear ? .blue : .gray).underline(viewmodel.timeRange == .thisYear)
                
            }
            )
        }.padding(.top,8)
            .padding(.bottom,16)
    }
    private var ratesFluctuationListView : some View{
        List(searchResult){ fluctuation in
            NavigationLink (destination: RatesFluctuationDetailView(baseCurrency: "BRL", rateFluctuation: fluctuation)){
                VStack{
                    HStack(alignment:.center,spacing: 8){
                        Text("\(fluctuation.symbol) / \(viewmodel.baseCurrency)").font(.system(size: 14,weight: .medium))
                        
                        Text(fluctuation.endRate.formater(decimalPlaces: 2)).font(.system(size:14,weight:.bold))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .trailing)
                        Text(fluctuation.change.formater(decimalPlaces: 4,with: true)).font(.system(size: 14,weight: .bold)).foregroundStyle(fluctuation.change.color)
                        
                        Text("(\(fluctuation.changePct.toPercentage()))").font(.system(size: 14,weight: .bold))
                            .foregroundStyle(fluctuation.changePct.color)
                    }
                    Divider().padding(.leading,-20).padding(.trailing,-40)
                    
                }
                
            }.listRowSeparator(.hidden)
                .listRowBackground(Color.white)
            
        }.listStyle(.plain)
    }
    
    
}
extension RatesFluctuationView : BaseCurrencyFilterViewDelegate{
    func didSelected(baseCurrency: String) {
        viewmodel.baseCurrency = baseCurrency
        viewmodel.doFetchRatesFluctuation(timeRange: .today)
    }
    
    
}
extension RatesFluctuationView : MulticurrenciesfilterViewDelegate{
    func didSelecteds(_ currencies: [String]) {
        viewmodel.currencies = currencies
        viewmodel.doFetchRatesFluctuation(timeRange: .today)
    }
    
   
    
    
}

#Preview {
    RatesFluctuationView()
}

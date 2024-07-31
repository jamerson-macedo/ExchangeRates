//
//  RatesFluctuationView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 31/07/24.
//

import SwiftUI

struct Fluctuation :Identifiable,Equatable{
    let id = UUID()
    let symbol : String
    let change : Double
    let changePct : Double
    let endRate : Double
    
}

class FluctuationViewModel : ObservableObject{
    @Published var fluctuation : [Fluctuation] = [Fluctuation(symbol: "USD", change: 0.0008, changePct: 0.4175, endRate: 0.18857),
                                                  Fluctuation(symbol: "EUR", change: -0.0003, changePct: 0.1651, endRate: 0.181353)
    ]
    
}

struct RatesFluctuationView: View {
    @StateObject var viewmodel = FluctuationViewModel()
    @State private var searchText = ""
    var searchResult : [Fluctuation]{
        if searchText.isEmpty{
            return viewmodel.fluctuation
        }else {
            return viewmodel.fluctuation.filter{ element in
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
                    print("Filtrar moedas")
                }, label: {
                    Image(systemName: "slider.horizontal.3")
                })
            }
        }
    }
    private var CurrencyTimeFilterView : some View{
        HStack(alignment:.center,spacing: 16){
            Button(action: {
                print("Filtrar moeda")
            }, label: {
                Text("BRL").font(.system(size: 14,weight: .bold)).padding(.init(top: 4, leading: 9, bottom: 4, trailing: 8))
                    .foregroundColor(.white)
                    .overlay{
                        RoundedRectangle(cornerRadius: 8).stroke(.white,lineWidth: 1)
                    }
            }
            ).background(Color(UIColor.lightGray))
                .cornerRadius(8)
            
            Button(action: {
                print("1 Dia")
            }, label: {
                Text("1 Dia").font(.system(size: 14,weight: .bold))
                    .foregroundColor(.blue).underline()
                
            }
            )
            Button(action: {
                print("7 Dias")
            }, label: {
                Text("7 Dias").font(.system(size: 14,weight: .bold))
                    .foregroundColor(.gray)
                
            }
            )
            Button(action: {
                print("1 mes")
            }, label: {
                Text("1 Mês").font(.system(size: 14,weight: .bold))
                    .foregroundColor(.gray)
                
            }
            )
            Button(action: {
                print("6 mes")
            }, label: {
                Text("6 Meses").font(.system(size: 14,weight: .bold))
                    .foregroundColor(.gray)
                
            }
            )
            Button(action: {
                print("1 ano")
            }, label: {
                Text("1 Ano").font(.system(size: 14,weight: .bold))
                    .foregroundColor(.gray)
                
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
                        Text("\(fluctuation.symbol) / BRL").font(.system(size: 14,weight: .medium))
                        
                        Text(fluctuation.endRate.formater(decimalPlaces: 2)).font(.system(size:14,weight:.bold))
                        
                        Text(fluctuation.change.formater(decimalPlaces: 4,with: true)).font(.system(size: 14,weight: .bold)).foregroundStyle(fluctuation.change.color).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .trailing)
                        
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

#Preview {
    RatesFluctuationView()
}

//
//  CurrencySelectionFilterView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 01/08/24.
//

import SwiftUI

protocol MulticurrenciesfilterViewDelegate{
    func didSelecteds(_ currencies :[String])
}

struct CurrencySelectionFilterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @StateObject var viewmodel = ViewModel()
    @State private var selection : [String] = []
    
    var delegate : MulticurrenciesfilterViewDelegate?
    
   
    var body: some View {
        NavigationView {
            VStack{
                if case .loading = viewmodel.viewState{
                    ProgressView().scaleEffect(2.2,anchor: .center)
                }else if case .success = viewmodel.viewState{
                    listCurrencyView
                }else if case .failure = viewmodel.viewState{
                    erroView
                }
            }
        }.onAppear{
            viewmodel.doFetchCurrencySymbols()
        }
    }
    private var listCurrencyView : some View{
        List(viewmodel.searchResults,id: \.symbol){ item in
            Button{
                if selection.contains(item.symbol){
                    selection.removeAll { value in
                        value == item.symbol
                    }
                }
                else {
                    selection.append(item.symbol)
                }
                
            }label: {
                HStack{
                    Text(item.symbol).font(.system(size: 14,weight: .bold))
                    Text("-").font(.system(size: 14,weight: .semibold))
                    Text(item.fullname).font(.system(size: 14,weight: .semibold))
                    Spacer()
                    Image(systemName: "checkmark").opacity(selection.contains(item.symbol) ? 1.0 : 0.0)
                }
            }.foregroundColor(.primary)
            
        }.searchable(text: $searchText,prompt: "Buscar moeda base")
            .onChange(of: searchText){ searchText in
                if searchText.isEmpty{
                    viewmodel.searchResults = viewmodel.currencySymbols
                }else {
                    viewmodel.searchResults = viewmodel.currencySymbols.filter({ $0.symbol.contains(searchText.uppercased()) || $0.fullname.uppercased().contains(searchText.uppercased())
                    })
                }
            }
            .navigationTitle("Filtrar Moedas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button(action: {
                    delegate?.didSelecteds(selection)
                    dismiss()
                    
                }, label: {
                    Text(selection.isEmpty ? "Cancelar" : "Ok").fontWeight(.bold)
                })
            }
    }
    private var erroView : some View{
        VStack(alignment: .center){
            Spacer()
            Image(systemName: "wifi.exclamationmark").resizable().frame(width: 60,height: 44).padding(.bottom,4)
            Text("Ocorreu um erro na busca dos Simbolos das Moedas!!").font(.headline.bold()).multilineTextAlignment(.center)
            
            Button{
                viewmodel.doFetchCurrencySymbols()
            }label: {
                Text("Tentar novamente?")
            }.padding(.top,4)
            Spacer()
        }.padding()
    }
}

#Preview {
    CurrencySelectionFilterView()
}

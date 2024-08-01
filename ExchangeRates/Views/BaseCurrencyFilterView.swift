//
//  BaseCurrencyFilterView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 01/08/24.
//

import SwiftUI


struct Symbol : Identifiable,Equatable{
    let id = UUID()
    var symbol : String
    var fullname :String
}
class BaseCurrencyFilterViewModel :ObservableObject{
    @Published var symbols :[Symbol] = [
    Symbol(symbol: "BRL", fullname: "Brazilian real"),
    Symbol(symbol: "EUR", fullname: "Euro"),
    Symbol(symbol: "JPY", fullname: "Japanese Yen"),
    ]
}
struct BaseCurrencyFilterView: View {
    @StateObject var viewmodel = BaseCurrencyFilterViewModel()
    @State private var selectedFilter :String?
    @State private var searchText = ""
    
    @Environment(\.dismiss) var dismiss
    
    var searchResult : [Symbol]{
        if searchText.isEmpty{
            return viewmodel.symbols
        }else {
            return viewmodel.symbols.filter{ text in
                text.symbol.contains(searchText.uppercased()) || text.fullname.uppercased().contains(searchText.uppercased())
            }
        }
    }
    var body: some View {
        NavigationView{
            listCurrencyView
        }
    }
    private var listCurrencyView : some View{
        List(searchResult,id: \.symbol,selection: $selectedFilter){ item in
            HStack{
                Text(item.symbol).font(.system(size: 14,weight: .bold))
                Text("-").font(.system(size: 14,weight: .semibold))
                Text(item.fullname).font(.system(size: 14,weight: .semibold))
            }
            
        }.searchable(text: $searchText)
            .navigationTitle("Filtrar Moedas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button(action: {
                    dismiss()
                    
                }, label: {
                    Text("OK").fontWeight(.bold)
                })
            }
    }
    
}

#Preview {
    BaseCurrencyFilterView()
}

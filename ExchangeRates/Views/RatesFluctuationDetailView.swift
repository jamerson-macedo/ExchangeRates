//
//  RatesFluctuationDetailsView.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 31/07/24.
//

import SwiftUI
import Charts



class RateFluctuationViewModel : ObservableObject{
    @Published var fluctuation : [RateFluctuationModel] = [RateFluctuationModel(symbol: "USD", change: 0.0008, changePct: 0.4175, endRate: 0.18857),
                                                  RateFluctuationModel(symbol: "EUR", change: -0.0003, changePct: 0.1651, endRate: 0.181353)
    ]
    
    @Published var chartComparations : [RateHistoricalModel] = [RateHistoricalModel(symbol: "USD", period: "2022-12-13".toDate(), endRate: 0.18857),RateHistoricalModel(symbol: "USD", period: "2023-01-03".toDate(), endRate: 0.18957),RateHistoricalModel(symbol: "USD", period: "2023-01-13".toDate(), endRate: 0.22857)]
    
    @Published var timeRange = TimeRangeEnum.today
    var yAxisMin:Double{
        let min = chartComparations.map{$0.endRate}.min() ?? 0.0
        return (min - (min * 0.02))
    }
    var yAxisMax:Double{
        let max = chartComparations.map{$0.endRate}.max() ?? 0.0
        return (max - (max * 0.02))
    }
    var  hasRates:Bool{
        return chartComparations.filter { $0.endRate > 0}.count > 0
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
    
}
struct RatesFluctuationDetailView: View {
    @StateObject var viewmodel = RateFluctuationViewModel()
    @State var baseCurrency : String
    @State var rateFluctuation : RateFluctuationModel
    
    @State private var isPresentedCurrencyFilter = false
    var body: some View {
        ScrollView(showsIndicators:false){
            valuesView
            graphicChatView
            comparationView
        }.padding(.leading,8)
            .padding(.trailing,8)
        .navigationTitle("BRL a EUR")
    }
    private var valuesView : some View{
        HStack(alignment:.center){
            Text(rateFluctuation.endRate.formater(decimalPlaces: 4)).font(.system(size: 28,weight: .bold))
            Text(rateFluctuation.changePct.toPercentage(with: true))
                .font(.system(size: 18,weight: .semibold))
                .foregroundStyle(rateFluctuation.changePct.color)
                .background(rateFluctuation.changePct.color).opacity(0.2)
            Text(rateFluctuation.change.formater(decimalPlaces: 4,with: true)).font(.system(size: 18,weight: .semibold))
                .foregroundStyle(rateFluctuation.change.color)
            Spacer()
        }.padding(.all,8)
    }
    private var graphicChatView :some View{
        VStack{
            periodFilterView
            lineChartView
            
        }.padding(.top,8)
            .padding(.bottom,8)
    }
    private var periodFilterView:some View{
        HStack(spacing:16){
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
        }
    }
    private var lineChartView : some View{
        Chart(viewmodel.chartComparations){ item in
            LineMark(x: .value("Time", item.period), y: .value("Rates", item.endRate)).interpolationMethod(.catmullRom)
            
            if !viewmodel.hasRates{
                RuleMark(y: .value("Conversão zero", 0)).annotation(position: .overlay,alignment:.center){
                    Text("Sem valores nesse periodo").font(.footnote).padding().background(Color(UIColor.systemBackground))
                }
            }
        }.chartYAxis{
            AxisMarks(position: .leading){ rates in
                AxisGridLine()
                AxisValueLabel(rates.as(Double.self)?.formater(decimalPlaces: 3) ?? 0.0.formater(decimalPlaces: 3))
                
            }
        }
        .chartXAxis{
            AxisMarks(preset: .aligned){ date in
                AxisGridLine()
                AxisValueLabel(viewmodel.xAxislabelFormatSTyle(for: date.as(Date.self) ?? Date()))
            }
        }
        .chartYScale(domain: viewmodel.yAxisMin...viewmodel.yAxisMax)
        .frame(height: 260)
        .padding(.trailing,18)
       
       

    }
    private var comparationView : some View{
        VStack(spacing:8){
            comparationButtonView
            comparationScrollView
            Spacer()
        }.padding(.top,8)
            .padding(.bottom,8)
    }
    private var comparationButtonView : some View{
        Button(action: {
            isPresentedCurrencyFilter.toggle()
        }, label: {
            Image(systemName: "magnifyingglass")
            Text("Comparar com").font(.system(size: 16))
        }).fullScreenCover(isPresented: $isPresentedCurrencyFilter){
            BaseCurrencyFilterView()
        }
        
    }
    private var comparationScrollView: some View{
        ScrollView(.horizontal,showsIndicators: false){
            LazyHGrid(rows: [GridItem(.flexible())],alignment: .center){
                ForEach(viewmodel.fluctuation){ fluctuation in
                    Button{
                        print()
                    }label: {
                        VStack(alignment: .leading,spacing: 4){
                            Text("\(fluctuation.symbol) / \(baseCurrency)").font(.system(size: 14)).foregroundStyle(Color.black)
                            Text(fluctuation.endRate.formater(decimalPlaces: 4)).font(.system(size: 14,weight: .semibold)).foregroundStyle(Color.black)
                            HStack(alignment: .bottom,spacing: 60){
                                Text(fluctuation.symbol).font(.system(size: 12,weight: .semibold)).foregroundStyle(Color.gray)
                                Text(fluctuation.changePct.toPercentage()).font(.system(size: 14,weight: .semibold)).foregroundStyle(fluctuation.changePct.color).frame(maxWidth: .infinity,alignment: .trailing)
                            }
                            
                        }.padding(.horizontal,16)
                            . padding(.vertical,8)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10).stroke(.gray,lineWidth: 1)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RatesFluctuationDetailView(baseCurrency: "BRL", rateFluctuation: RateFluctuationModel(symbol: "EUR", change: -0.0003, changePct: 0.1651, endRate: 0.181353))
}

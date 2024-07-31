//
//  TimeRangeEnum.swift
//  ExchangeRates
//
//  Created by Jamerson Macedo on 31/07/24.
//

import Foundation
enum TimeRangeEnum{
    case today
    case thisWeek
    case thisMonth
    case thisSemester
    case thisYear
    var date : Date{
        switch self {
        case .today : return Date(form: .day, value: 1)
        case .thisWeek : return Date(form: .day, value: 6)
        case .thisMonth : return Date(form: .month, value: 1)
        case .thisSemester : return Date(form: .month, value: 6)
        case .thisYear : return Date(form: .year, value: 1)
            
        }
    }
}

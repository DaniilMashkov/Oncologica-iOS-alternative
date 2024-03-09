//
//  Extensions.swift
//  Oncologica
//
//  Created by Daniil Mashkov on 03.01.2024.
//

import Foundation
import SwiftUI

extension Date {
    func startOfMonth() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    func endOfMonth() -> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth())!
    }
    
    func weekDays() -> [String] {
        let formatter = DateFormatter()
        let symbols = formatter.shortWeekdaySymbols
        let firstWeekday = 2
        return Array(symbols![firstWeekday-1..<symbols!.count]) + symbols![0..<firstWeekday-1]
    }
    
    func datesRangeArray(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    func currentMonthRange() -> [Date] {
        return datesRangeArray(from: startOfMonth(), to: endOfMonth())
    }
    
    func firstDayOfTheMonth() -> Int {
        let c = Calendar.current.dateComponents([.calendar, .year,.month], from: self).date!
        let wd = Calendar.current.component(.weekday, from: c)
        
        if wd == 1{
            return 6
        }
        return wd-2
    }
    
    func yearsRange(get values: String) -> [Date] {
        var from = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let to = Calendar.current.date(byAdding: .year, value: +2, to: Date())
        
        var dates: [Date] = []
        while from! <= to! {
            dates.append(from!)
            switch values {
            case "month":
                guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: from!) else { break }
                from = newDate
            default:
                guard let newDate = Calendar.current.date(byAdding: .year, value: 1, to: from!) else { break }
                from = newDate
            }
            
        }
        return dates
    }
    
    func monthsRange() -> [Date] {
        let range = 1...12
        var dates: [Date] = []
        
        for num in range {
            let newDate = Calendar.current.date(byAdding: .month, value: num, to: self)!
            dates.append(newDate)
        }
        return dates
    }
    
    func toString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    func toDate(_ format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
}

extension Calendar {
    
    func my() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        
        return calendar
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    func filterButton(text: String) -> Color {
        if text == "Не пойду" {
            return Color(.red)
        }
        if ["Записан", "Мастер-класс"].contains(text) {
            return Color(.green)
        }
        if text == "Очно" {
            return Color(.cyan)
        }
        if text == "Встреча команды" {
            return Color(.gray)
        }
        if ["Прямой эфир", "В резерве"].contains(text) {
            return Color(.orange)
        } else {
            return Color(.gray)
        }
    }
}


extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


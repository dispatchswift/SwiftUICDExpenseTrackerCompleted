//
//  Extensions.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

extension Date {
	var year: Int { Calendar.current.dateComponents([.year], from: self).year ?? 0 }
	var month: Int { Calendar.current.dateComponents([.month], from: self).month ?? 0 }
}

extension String {
	var getMonthInt: Int { Calendar.current.shortMonthSymbols.firstIndex(of: self)! + 1 }
}

extension Double {
	func formattedCurrencyText(_ type: CurrencyType) -> String {
		let formatter = NumberFormatter()
		formatter.isLenient = true
		formatter.numberStyle = .currency
		formatter.currencyCode = type.rawValue.uppercased()
		
		return formatter.string(from: NSNumber(value: self)) ?? "0"
	}
}

extension View {
	var backport: Backport<Self> { Backport(self) }
	
	func hideListRowSeparator() -> some View {
		modifier(HideRowSeparatorViewModifier())
	}
}

//
//  MonthlyView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct MonthlyView: View {
	@Binding var selectedMonths: Set<Int>
	
	private let shortMonthSymbols: [String] = Calendar.current.shortMonthSymbols
	
	private var topRowLength: Int {
		(shortMonthSymbols.count / 2) + (shortMonthSymbols.count % 2)
	}
	
	var body: some View {
		VStack(spacing: 12) {
			HStack(spacing: 0) {
				ForEach(shortMonthSymbols.prefix(upTo: topRowLength), id: \.self) { monthSymbol in
					MonthlyButtonView(selectedMonths: $selectedMonths, title: monthSymbol)
				}
			}
			
			HStack(spacing: 0) {
				ForEach(shortMonthSymbols.suffix(from: topRowLength), id: \.self) { monthSymbol in
					MonthlyButtonView(selectedMonths: $selectedMonths, title: monthSymbol)
				}
			}
		}
		.padding()
	}
}

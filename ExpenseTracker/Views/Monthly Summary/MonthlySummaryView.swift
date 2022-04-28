//
//  MonthlySummaryView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct MonthlySummaryView: View {
	@State var selectedMonths: Set<Int> = [Date().month]
	
	var body: some View {
		NavigationView {
			ScrollView(showsIndicators: false) {
				VStack(spacing: 0) {
					MonthlyView(selectedMonths: $selectedMonths)					
					MonthlyLogsListView(selectedMonths: $selectedMonths)
				}
			}
			.navigationBarTitle("", displayMode: .inline)
			.navigationBarItems(
				leading:
					Text("Monthly Summary")
					.font(.title)
					.fontWeight(.bold)
				,
				trailing:
					Button {
						selectedMonths = [Date().month]
					} label: {
						Text("Reset")
							.opacity(selectedMonths.count > 1 ? 1 : 0)
					}
			)
		}
	}
}

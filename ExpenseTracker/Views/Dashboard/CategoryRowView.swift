//
//  CategoryRowView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct CategoryRowView: View {
	let category: Category
	let total: Double
	
	var body: some View {
		HStack(spacing: 16) {
			CategoryImageView(category: category)
			
			Text(category.rawValue.capitalized)
			
			Spacer()
			
			Text(total.formattedCurrencyText(.usd))
				.font(.headline)
		}
		.padding()
		.overlay(
			RoundedRectangle(cornerRadius: 4)
				.stroke(Color.black, lineWidth: 1)
		)
	}
}

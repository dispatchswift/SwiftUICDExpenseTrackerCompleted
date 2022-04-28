//
//  DashboardModels.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import Foundation

struct CategorySum: Identifiable, Equatable {
	let sum: Double
	let category: Category
	
	var id: String { "\(category)\(sum)" }
}

struct UpdateCurrencyPostModel: Encodable {
	let amount: Double
	let toCurrency: String
	let fromCurrency: String
	
	enum CodingKeys: String, CodingKey {
		case amount
		case toCurrency = "to_currency"
		case fromCurrency = "from_currency"
	}
}

struct UpdateCurrencyResponseModel: Decodable {
	let amount: Double
	let rate: Double
}


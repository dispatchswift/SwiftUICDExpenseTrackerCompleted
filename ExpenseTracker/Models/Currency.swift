//
//  Currency.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import Foundation

struct Currency: Equatable {
	let imageName: String
	let type: CurrencyType
}

extension Currency: Identifiable {
	var id: String { type.rawValue }
}

extension Currency {
	static let usd = Currency(imageName: "dollarsign.circle", type: .usd)
}

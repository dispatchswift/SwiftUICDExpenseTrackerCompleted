//
//  CurrencyType.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import Foundation

enum CurrencyType: String, CaseIterable {
	case usd
	case eur
}

extension CurrencyType: Identifiable {
	var id: String { rawValue }
}

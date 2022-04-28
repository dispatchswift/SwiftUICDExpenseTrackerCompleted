//
//  CategorySum.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

struct CategorySum: Identifiable, Equatable {
	let sum: Double
	let category: Category
	
	var id: String { "\(category)\(sum)" }
}

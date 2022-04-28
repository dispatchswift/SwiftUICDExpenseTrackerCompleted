//
//  DashboardViewModel.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI
import CoreData

class DashboardViewModel: ObservableObject {
	@Published var expensesTotal: Double = 0.0
	@Published var categories: [CategorySum] = []
	@Published var isUpdatingCurrency = false
	
	private var context: NSManagedObjectContext?
	private let service: APIServiceProtocol
	
	init(context: NSManagedObjectContext, service: APIServiceProtocol) {
		self.context = context
		self.service = service
	}
	
	func updateTotalExpenses() {
		ExpenseLog.fetchTotalExpenseOfAllCategories(context: self.context!) { results in
			guard !results.isEmpty else { return }
			
			self.expensesTotal = results.map { $0.sum }.reduce(0, +)
			self.categories = results.map { CategorySum(sum: $0.sum, category: $0.category) }
		}
	}
	
	func convertCurrency(amount: Double, toCurrency: String, fromCurrency: String) {
		service.updateCurrency(
			amount: amount,
			toCurrency: toCurrency,
			fromCurrency: fromCurrency
		) { result in
			self.isUpdatingCurrency = false
			
			switch result {
			case .success(let response):
				self.expensesTotal = response.amount
				
			case .failure(let error):
				debugPrint(error)
			}
		}
	}
}

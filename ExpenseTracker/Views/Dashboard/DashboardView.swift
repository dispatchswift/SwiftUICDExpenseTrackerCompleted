//
//  DashboardView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardView: View {
	@Environment(\.managedObjectContext) var context: NSManagedObjectContext
	
	@State private var expensesTotal: Double = 0.0
	@State private var categories: [CategorySum] = []
	
	@State private var currencyType: CurrencyType = .usd
	@State private var previousCurrencyType: CurrencyType = .usd
	
	@State private var selectedCurrency: Currency = .usd
	
	@State private var showsCurrencySelectionView = false
	@State private var isUpdatingCurrency = false
	
	private let service = APIService()
	
	var body: some View {
		NavigationView {
			ScrollView(showsIndicators: false) {
				if !categories.isEmpty {
					VStack(spacing: 0) {
						pieChartView
						totalExpensesView
						Divider()
						categoriesListView
					}
					.padding()
				} else {
					Text("No expenses data\nPlease add your expenses from the logs tab")
						.font(.headline)
						.multilineTextAlignment(.center)
						.padding(.horizontal)
				}
			}
			.navigationBarTitle("", displayMode: .inline)
			.navigationBarItems(trailing: currencySelectorBarItem)
			.onAppear {
				guard selectedCurrency.type == previousCurrencyType else { return }
				updateTotalExpenses()
			}
		}
	}
}

// MARK: - Views
extension DashboardView {
	
	var pieChartView: some View {
		Group {
			if expensesTotal > 0 {
				PieChartView(
					data: categories.map { ($0.sum, $0.category.color) },
					style: Styles.pieChartStyleOne,
					form: CGSize(width: 300, height: 240),
					dropShadow: false
				)
			}
		}
	}
	
	var totalExpensesView: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text("Total Expenses")
				.font(.title)
			
			Text(expensesTotal.formattedCurrencyText(selectedCurrency.type))
				.font(.title)
				.fontWeight(.bold)
				.foregroundColor(isUpdatingCurrency ? .secondary : .primary)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.vertical)
	}
	
	var categoriesListView: some View {
		ForEach(categories) {
			CategoryRowView(category: $0.category, total: $0.sum)
		}
		.padding(.vertical, 4)
	}
	
	var currencySelectorBarItem: some View {
		Group {
			if !categories.isEmpty {
				Button {
					showsCurrencySelectionView = true
				} label: {
					NavigationLink(
						isActive: $showsCurrencySelectionView,
						destination: {
							CurrencySelectionView(selection: $selectedCurrency)
								.onDisappear {
									guard selectedCurrency.type != previousCurrencyType else { return }
									
									self.isUpdatingCurrency = true
									self.previousCurrencyType = selectedCurrency.type
									
									convertCurrency(amount: expensesTotal,
																	toCurrency: selectedCurrency.type.rawValue.uppercased(),
																	fromCurrency: previousCurrencyType.rawValue.uppercased())
								}
						},
						label: {
							if isUpdatingCurrency {
								if #available(iOS 14, *) {
									ProgressView()
										.padding(.all, 4)
								} else {
									ActivityIndicator(isAnimating: isUpdatingCurrency)
								}
							} else {
								Image(systemName: selectedCurrency.imageName)
									.padding(.all, 4)
									.foregroundColor(.white)
									.background(Color.blue)
									.clipShape(Circle())
									.shadow(radius: 3)
							}
						}
					)
				}
			}
		}
	}
}

// MARK: - Methods
extension DashboardView {
	
	func updateTotalExpenses() {
		ExpenseLog.fetchTotalExpenseOfAllCategories(context: self.context) { results in
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
			isUpdatingCurrency = false
			
			switch result {
			case .success(let response):
				expensesTotal = response.amount
				
			case .failure(let error):
				debugPrint(error)
			}
		}
	}
}

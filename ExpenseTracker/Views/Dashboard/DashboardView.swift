//
//  DashboardView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardView: View {
	@ObservedObject private var viewModel: DashboardViewModel
	
	@State private var currencyType: CurrencyType = .usd
	@State private var previousCurrencyType: CurrencyType = .usd
	
	@State private var selectedCurrency: Currency = .usd
	
	@State private var showsCurrencySelectionView = false
	
	init(context: NSManagedObjectContext) {
		viewModel = DashboardViewModel(context: context, service: APIService())
	}
	
	var body: some View {
		NavigationView {
			ScrollView(showsIndicators: false) {
				if !viewModel.categories.isEmpty {
					VStack(spacing: 0) {
						pieChartView
						totalExpensesView
						Divider()
						categoriesListView
					}
					.padding()
				} else {
					emptyDataView
				}
			}
			.navigationBarTitle("", displayMode: .inline)
			.navigationBarItems(trailing: currencySelectorBarItem)
			.onAppear {
				guard selectedCurrency.type == previousCurrencyType else { return }
				viewModel.updateTotalExpenses()
			}
		}
	}
}

// MARK: - Views
extension DashboardView {
	
	var emptyDataView: some View {
		Text("No expenses data\nPlease add your expenses from the logs tab")
			.font(.headline)
			.multilineTextAlignment(.center)
			.padding(.horizontal)
	}
	
	var pieChartView: some View {
		Group {
			if viewModel.expensesTotal > 0 {
				PieChartView(
					data: viewModel.categories.map { ($0.sum, $0.category.color) },
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
			
			Text(viewModel.expensesTotal.formattedCurrencyText(selectedCurrency.type))
				.font(.title)
				.fontWeight(.bold)
				.foregroundColor(viewModel.isUpdatingCurrency ? .secondary : .primary)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.vertical)
	}
	
	var categoriesListView: some View {
		ForEach(viewModel.categories) {
			CategoryRowView(category: $0.category, total: $0.sum)
		}
		.padding(.vertical, 4)
	}
	
	var currencySelectorBarItem: some View {
		Group {
			if !viewModel.categories.isEmpty {
				Button {
					showsCurrencySelectionView = true
				} label: {
					NavigationLink(
						isActive: $showsCurrencySelectionView,
						destination: {
							CurrencySelectionView(selection: $selectedCurrency)
								.onDisappear {
									guard selectedCurrency.type != previousCurrencyType else { return }
									
									viewModel.isUpdatingCurrency = true
									self.previousCurrencyType = selectedCurrency.type
									
									viewModel.convertCurrency(amount: viewModel.expensesTotal,
																						toCurrency: selectedCurrency.type.rawValue.uppercased(),
																						fromCurrency: previousCurrencyType.rawValue.uppercased())
								}
						},
						label: {
							if viewModel.isUpdatingCurrency {
								if #available(iOS 14, *) {
									ProgressView()
										.padding(.all, 4)
								} else {
									ActivityIndicator(isAnimating: viewModel.isUpdatingCurrency)
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

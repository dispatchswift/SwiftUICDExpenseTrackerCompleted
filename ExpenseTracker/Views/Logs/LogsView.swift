//
//  LogsView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogsView: View {
	@Environment(\.managedObjectContext) var context
	
	@State private var searchText: String = ""
	@State private var searchBarHeight: CGFloat = 0
	
	@State private var sortType = SortType.date
	@State private var sortOrder = SortOrder.descending
	
	@State private var selectedCategories: Set<Category> = Set()
	
	@State private var isAddFormPresented: Bool = false
    
	init() {
		UITableView.appearance().showsVerticalScrollIndicator = false
	}
	
	var body: some View {
		NavigationView {
			VStack(spacing: 0) {
				if #available(iOS 14, *) {
					EmptyView()
				} else {
					SearchBar(text: $searchText, keyboardHeight: $searchBarHeight, placeholder: "Search expenses")
				}
				
				FilterCategoriesView(selectedCategories: $selectedCategories)
				
				SelectSortOrderView(sortType: $sortType, sortOrder: $sortOrder)
				
				Divider()
				
				LogsListView(
					predicate: ExpenseLog.predicate(with: Array(selectedCategories), searchText: searchText),
					sortDescriptor: ExpenseLogSort(sortType: sortType, sortOrder: sortOrder).sortDescriptor
				)
			}
			.navigationBarTitle("", displayMode: .inline)
			.navigationBarItems(
				leading:
					Text("Expense Logs")
					.font(.title)
					.fontWeight(.bold)
				,
				trailing:
					Button {
						isAddFormPresented = true
					} label: {
						Image(systemName: "plus")
					}
			)
			.sheet(isPresented: $isAddFormPresented) {
				LogFormView(context: self.context)
			}
			.backport.searchBar(searchText: $searchText)
		}
	}
}

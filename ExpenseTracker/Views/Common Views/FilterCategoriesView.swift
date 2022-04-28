//
//  FilterCategoriesView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct FilterCategoriesView: View {
	@Binding var selectedCategories: Set<Category>
	
	private let categories = Category.allCases
    
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				ForEach(categories) { category in
					FilterCategoriesButtonView(
						category: category,
						isSelected: self.selectedCategories.contains(category),
						onTap: self.onTap
					)
					.padding(.leading, category == self.categories.first ? 16 : 0)
					.padding(.trailing, category == self.categories.last ? 16 : 0)
				}
			}
		}
	}
}

// MARK: - Methods
extension FilterCategoriesView {
	
	func onTap(category: Category) {
		if selectedCategories.contains(category) {
			selectedCategories.remove(category)
		} else {
			selectedCategories.insert(category)
		}
	}
}

//
//  FilterCategoriesButtonView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct FilterCategoriesButtonView: View {
	
	var category: Category
	var isSelected: Bool
	var onTap: (Category) -> ()
	
	var body: some View {
		Button(action: {
			self.onTap(self.category)
		}) {
			HStack(spacing: 8) {
				Text(category.rawValue.capitalized)
					.fixedSize(horizontal: true, vertical: true)
				
				if isSelected {
					Image(systemName: "xmark.circle.fill")
				}
			}
			.padding(.vertical, 8)
			.padding(.horizontal, 16)
			
			.overlay(
				RoundedRectangle(cornerRadius: 16)
					.stroke(isSelected ? category.color : Color(UIColor.lightGray), lineWidth: 1))
			.frame(height: 44)
		}
		.foregroundColor(isSelected ? category.color : Color(UIColor.gray))
	}
}

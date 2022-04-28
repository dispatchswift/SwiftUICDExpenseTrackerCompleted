//
//  SelectSortOrderView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct SelectSortOrderView: View {
	@Binding var sortType: SortType
	@Binding var sortOrder: SortOrder
	
	var body: some View {
		HStack {
			Group {
				Text("Sort by")
				
				Picker(selection: $sortType) {
					ForEach(SortType.allCases) { type in
						Image(systemName: type == .date ? "calendar" : "dollarsign.circle")
							.tag(type)
					}
				} label: {
					Text("Sort by")
				}
				.pickerStyle(SegmentedPickerStyle())
			}
			
			Group {
				Text("Order by")
				
				Picker(selection: $sortOrder) {
					ForEach(SortOrder.allCases) { order in
						Image(systemName: order == .ascending ? "arrow.up" : "arrow.down")
							.tag(order)
					}
				} label: {
					Text("Order")
				}
				.pickerStyle(SegmentedPickerStyle())
			}
		}
		.padding()
	}
}

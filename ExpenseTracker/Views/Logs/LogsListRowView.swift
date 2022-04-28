//
//  LogsListRowView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct LogsListRowView: View {
	let log: ExpenseLog
	@Binding var logToEdit: ExpenseLog?
	
	var body: some View {
		Button {
			self.logToEdit = log
		} label: {
			HStack(spacing: 16) {
				CategoryImageView(category: log.categoryEnum)
				
				VStack(alignment: .leading, spacing: 0) {
					Text(log.nameText)
						.multilineTextAlignment(.leading)
						.font(.headline)
						.foregroundColor(.primary)
					
					Text(log.dateText)
						.font(.body)
						.foregroundColor(.secondary)
				}
				
				Spacer()
				
				Text(log.amountText)
					.font(.headline)
					.foregroundColor(.primary)
			}
			.padding()
		}
		.overlay(
			RoundedRectangle(cornerRadius: 4)
				.stroke(Color.black, lineWidth: 1)
		)
	}
}

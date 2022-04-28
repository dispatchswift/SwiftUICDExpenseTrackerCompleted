//
//  MonthlyButtonView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct MonthlyButtonView: View {
	@Binding var selectedMonths: Set<Int>
	
	var title: String
	
	private var isSelected: Bool {
		selectedMonths.contains(title.getMonthInt)
	}
	
	var body: some View {
		Button {
			UIImpactFeedbackGenerator(style: .light).impactOccurred()
			
			if isSelected {
				selectedMonths.remove(title.getMonthInt)
			} else {
				selectedMonths.insert(title.getMonthInt)
			}
		} label: {
			Text(title)
				.font(.system(size: 12))
				.fontWeight(.semibold)
				.foregroundColor(isSelected ? Color.white : Color.black)
				.rotationEffect(Angle(degrees: -8))
				.padding()
				.background(isSelected ? Color.blue : Color.clear)
				.clipShape(Circle())
				.overlay(
					Circle()
						.stroke(isSelected ? Color.blue : Color.gray, lineWidth: 1)
				)
		}
		.frame(maxWidth: .infinity)
	}
}

//
//  HideRowSeparatorViewModifier.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct HideRowSeparatorViewModifier: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 15, *) {
			content.listRowSeparator(.hidden)
		}
	}
}

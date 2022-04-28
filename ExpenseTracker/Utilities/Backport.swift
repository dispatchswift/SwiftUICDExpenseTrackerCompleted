//
//  Backport.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

public struct Backport<Content> {
	public let content: Content
	
	public init(_ content: Content) {
		self.content = content
	}
}

extension Backport where Content: View {
	@ViewBuilder func searchBar(searchText: Binding<String>) -> some View {
		if #available(iOS 15, *) {
			content
				.searchable(text: searchText, placement: .navigationBarDrawer(displayMode: .always))
		}
	}
}

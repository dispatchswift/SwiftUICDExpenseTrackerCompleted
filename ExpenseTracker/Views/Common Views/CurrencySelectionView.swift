//
//  CurrencySelectionView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct CurrencySelectionView: View {
	@Environment(\.presentationMode) var presentationMode
	
	@Binding var selection: Currency
	
	private let currencies =  [
		Currency(imageName: "dollarsign.circle", type: .usd),
		Currency(imageName: "eurosign.circle", type: .eur)
	]
	
	var body: some View {
		List(currencies) { currency in
			Button {
				selection = currency
				presentationMode.wrappedValue.dismiss()
			} label: {
				HStack {
					Image(systemName: currency.imageName)
					Text(currency.type.rawValue.uppercased())
					Spacer()
					
					if currency == selection {
						Image(systemName: "checkmark")
					}
				}
				.foregroundColor(currency.type == selection.type ? .blue : .black)
			}
		}
	}
}

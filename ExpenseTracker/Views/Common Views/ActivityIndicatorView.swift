//
//  ActivityIndicatorView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
	typealias UIView = UIActivityIndicatorView
	
	var isAnimating: Bool
	
	func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
		UIView()
	}
	
	func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
		isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
	}
}

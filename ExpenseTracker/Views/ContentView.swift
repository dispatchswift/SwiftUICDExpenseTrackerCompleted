//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData
 
struct ContentView: View {
	@Environment(\.managedObjectContext) var context
	
	var body: some View {
		TabView {
			DashboardView(context: context)
				.tabItem {
					VStack {
						Image(systemName: "chart.pie")
						Text("Dashboard")
					}
				}
				.tag(0)
			
			LogsView()
				.tabItem {
					VStack {
						Image(systemName: "tray")
						Text("Logs")
					}
				}
				.tag(1)
			
			MonthlySummaryView()
				.tabItem {
					VStack {
						Image(systemName: "list.bullet.below.rectangle")
						Text("Summary")
					}
				}
				.tag(2)
		}
	}
}

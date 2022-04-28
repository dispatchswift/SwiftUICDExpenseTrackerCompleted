//
//  MonthlyLogsListView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI
import CoreData

struct MonthlyLogsListView: View {
	@Environment(\.managedObjectContext) private var context
	
	@FetchRequest(entity: ExpenseLog.entity(),
								sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)])
	
	private var fetchedResults: FetchedResults<ExpenseLog>
	
	private var logs: [ExpenseLog] {
		let logsByMonthDict = Dictionary(grouping: fetchedResults, by: { $0.date!.month })
		
		var expenseLogs: [ExpenseLog] = []
		
		selectedMonths.forEach { selectedMonth in
			if let log = logsByMonthDict[selectedMonth] {
				expenseLogs += log
			}
		}
		
		expenseLogs = expenseLogs.sorted { $0.date! > $1.date! }
		return expenseLogs
	}
	
	@Binding var selectedMonths: Set<Int>
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			if #available(iOS 14, *) {
				LazyVStack {
					ForEach(logs) { log in
						LogsListRowView(log: log, logToEdit: .constant(nil))
					}
				}
				.padding()
			} else {
				VStack {
					ForEach(logs) { log in
						LogsListRowView(log: log, logToEdit: .constant(nil))
					}
				}
				.padding()
			}
		}
	}
}

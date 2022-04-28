//
//  LogsListView.swift
//  ExpenseTracker
//
//  Copyright © 2022 Amari Duran. All rights reserved.
//

import SwiftUI
import CoreData

struct LogsListView: View {
	@Environment(\.managedObjectContext) private var context
	
	@FetchRequest(entity: ExpenseLog.entity(),
								sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)])
	
	private var fetchedLogs: FetchedResults<ExpenseLog>
	
	private var logsByMonthDict: [Int: [ExpenseLog]] {
		Dictionary(grouping: fetchedLogs, by: { $0.date!.month })
	}
	
	@State private var logToEdit: ExpenseLog?
	
	init(predicate: NSPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) {
		let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
		
		if let sortDescriptor = sortDescriptor {
			fetchRequest.sortDescriptors = [sortDescriptor]
		}
		
		if let predicate = predicate {
			fetchRequest.predicate = predicate
		}
		
		_fetchedLogs = FetchRequest(fetchRequest: fetchRequest)
	}
	
	var body: some View {
		List {
			ForEach(fetchedLogs) { log in
				LogsListRowView(log: log, logToEdit: $logToEdit)
			}
			.onDelete(perform: onDelete)
			.sheet(
				item: $logToEdit,
				onDismiss: {
					self.logToEdit = nil
				}, content: { log in
					LogFormView(
						logToEdit: log,
						context: self.context,
						name: log.name ?? "",
						amount: log.amount?.doubleValue ?? 0,
						category: Category(rawValue: log.category ?? "") ?? .food,
						date: log.date ?? Date(),
						notes: log.notes ?? ""
					)
				}
			)
			.hideListRowSeparator()
		}
		.listStyle(PlainListStyle())
	}
}

// MARK: - Methods
extension LogsListView {
	
	private func onDelete(with indexSet: IndexSet) {
		indexSet.forEach { index in
			let expenseLog = fetchedLogs[index]
			context.delete(expenseLog)
		}
		
		do {
			try context.saveContext()
		} catch {
			debugPrint(error.localizedDescription)
		}
	}
}

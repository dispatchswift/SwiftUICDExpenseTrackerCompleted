//
//  LogFormView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogFormView: View {
	@Environment(\.presentationMode) var presentationMode
	
	var logToEdit: ExpenseLog?
	var context: NSManagedObjectContext
	
	@State var name: String = ""
	@State var amount: Double = 0
	@State var category: Category = .utilities
	@State var date: Date = Date()
	@State var notes: String = ""
	
	var title: String {
		logToEdit == nil ? "Create Log" : "Edit Log"
	}
	
	var body: some View {
		NavigationView {
			Form {
				TextField("Name", text: $name)
					.disableAutocorrection(true)
				
				TextField("Amount", value: $amount, formatter: Utils.numberFormatter)
					.keyboardType(.numbersAndPunctuation)
				
				Picker(selection: $category, label: Text("Category")) {
					ForEach(Category.allCases) { category in
						Text(category.rawValue.capitalized)
							.tag(category)
					}
				}
				
				DatePicker(selection: $date, displayedComponents: .date) {
					Text("Date")
				}
				
				Section(header: Text("Notes")) {
					List {
						if #available(iOS 15.0, *) {
							TextEditor(text: $notes)
								.frame(minHeight: 100)
						} else {
							// TODO: - iOS 14.0
						}
					}
				}
			}
			.navigationBarTitle(title)
			.navigationBarItems(
				leading: Button(action: self.onCancelTapped) {
					Text("Cancel")
				},
				trailing: Button(action: self.onSaveTapped) {
					Text("Save")
				}
			)
		}
	}
}

// MARK: - Actions
extension LogFormView {
	private func onCancelTapped() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	private func onSaveTapped() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
		
		let log: ExpenseLog
		
		if let logToEdit = self.logToEdit {
			log = logToEdit
		} else {
			log = ExpenseLog(context: self.context)
			log.id = UUID()
		}
		
		log.name = self.name
		log.amount = NSDecimalNumber(value: self.amount)
		log.category = self.category.rawValue
		log.date = self.date
		log.notes = self.notes
		
		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		
		self.presentationMode.wrappedValue.dismiss()
	}
}

struct LogFormView_Previews: PreviewProvider {
	static var previews: some View {
		let stack = CoreDataStack(containerName: "ExpenseTracker")
		return LogFormView(context: stack.viewContext)
	}
}

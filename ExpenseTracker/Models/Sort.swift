//
//  Sort.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation
import Accessibility

enum SortType: String, CaseIterable {
	case date
	case amount
}

extension SortType: Identifiable {
	var id: String { rawValue }
}


enum SortOrder: String, CaseIterable {
	case ascending
	case descending
}

extension SortOrder: Identifiable {
	var id: String { rawValue }
}

struct ExpenseLogSort {
	var sortType: SortType
	var sortOrder: SortOrder
	
	var isAscending: Bool {
		sortOrder == .ascending ? true : false
	}
	
	var sortDescriptor: NSSortDescriptor {
		switch sortType {
		case .date:
			return NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: isAscending)
		case .amount:
			return NSSortDescriptor(keyPath: \ExpenseLog.amount, ascending: isAscending)
		}
	}
}

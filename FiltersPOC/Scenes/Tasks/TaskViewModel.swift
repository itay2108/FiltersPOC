//
//  TaskViewModel.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 12/02/2023.
//

import SwiftUI
import Filters
import Combine

class TaskViewModel: ObservableObject {
    
    var updatableValueSubscribers: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var tasks: [DSTask] = Array(1...20).map({ _ in .placeholder() })
    @Published var filters: [Filter<DSTask>] = RawTaskFilters.main.filters.asFilters(for: DSTask.self)
    
    @Published var error: Error?
    
    var relevantTasks: [DSTask] {
        return tasks.filtered(by: filters).sortedByDeadline()
    }
    
    var filterSheetHeights: Set<PresentationDetent> {
        return [.medium, .fraction(0.8)]
    }
    
    var activeFilters: [Filter<DSTask>] {
        return filters.filter({ !$0.activeValues.isEmpty })
    }
    
    func reloadTasks() {
        tasks = Array(1...20).map({ _ in .placeholder() })
    }
    
    func deactive(filter: Filter<DSTask>) {
        do {
            var deactivatedFilter = filter
            deactivatedFilter.deactivateAllValues()
            
            try filters.update(filter: deactivatedFilter)
            
            Haptics.shared.vibrate(.rigid)
        } catch {
            self.error = error
        }
    }
}

extension TaskViewModel: AnySubscribable {
    
    var updatableValue: [Filter<DSTask>]? {
        get {
            return filters
        }
        set {
            filters = newValue ?? filters
        }
    }
    
}

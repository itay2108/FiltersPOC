//
//  FilterCategoryViewModel.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 13/02/2023.
//

import Foundation
import Combine
import Filters

class FilterCategoryViewModel<T: Filterable>: ObservableObject {
    @Published var filters: [Filter<T>]?
    
    @Published var error: Error?
    
    var updatableValueSubscribers: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init<S: AnySubscribable>(syncWith subscribable: S)
    where S.SubscribableValueType == [Filter<T>] {
        
        self.filters = subscribable.updatableValue
        subscribable.subscribe(to: self)
    }
    
    init(filters: [Filter<T>]) {
        self.filters = filters
    }
    
    func resetFilters() {
        do {
            try filters?.forEach({ filter in
                var deactivatedFilter = filter
                deactivatedFilter.deactivateAllValues()
                try filters?.update(filter: deactivatedFilter)
            })
            
            Haptics.shared.vibrate(.rigid)
        } catch {
            self.error = error
        }
    }
}

extension FilterCategoryViewModel: AnySynchronizable {

    //subscribable
    var updatableValue: [Filter<T>]? {
        get {
            return filters
        }
        set {
            filters = newValue ?? filters
        }
    }
    
    //publishable
    var publishableValue: [Filter<T>]? {
        get {
            return filters
        }
        set {
            filters = newValue ?? filters
        }
    }
    
    var updatableValuePublisher: Published<[Filter<T>]?>.Publisher {
        return $filters
    }
    
}

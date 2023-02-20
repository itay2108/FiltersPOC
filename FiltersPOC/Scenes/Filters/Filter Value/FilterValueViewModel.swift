//
//  FilterValuesViewModel.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 14/02/2023.
//

import Foundation
import DSFilters

class FilterValuesViewModel<T: Filterable>: ObservableObject {
    @Published var allFilters: [Filter<T>]?
    
    @Published var filter: Filter<T> {
        didSet {
            updateFilters()
        }
    }
    
    @Published var error: Error?
    
    init<S: AnySubscribable>(filter: Filter<T>, syncWith subscribable: S)
    where S.SubscribableValueType == [Filter<T>] {
        self.filter = filter
        
        self.allFilters = subscribable.updatableValue
        subscribable.subscribe(to: self, dropsFirst: true)
    }
    
    init(filter: Filter<T>) {
        self.filter = filter
    }
    
    func toggleValue(_ value: AnyEquatable) {
        do {
            try filter.toggle(value: value)
        } catch {
            self.error = error
        }
    }
    
    func updateFilters() {
        do {
            try allFilters?.update(filter: filter)
        } catch {
            self.error = error
        }
    }
}

extension FilterValuesViewModel: AnyPublishable {

    var publishableValue: [Filter<T>]? {
        get {
            return allFilters
        }
        set {
            allFilters = newValue ?? allFilters
        }
    }
    
    var updatableValuePublisher: Published<[Filter<T>]?>.Publisher {
        return $allFilters
    }
    
}

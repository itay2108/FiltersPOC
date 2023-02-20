//
//  RawTaskFilters.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 13/02/2023.
//

import Foundation

class RawTaskFilters {
    static let main: RawTaskFilters = RawTaskFilters()
    
    var filters: [String: [Any]] {
        return ["deadline": ["today", "1 day left", "2 days left", "3 days left"],
                "favorite": ["yes", "no"],
                "importance": ["regular", "important", "very important", "urgent"]]
    }
}

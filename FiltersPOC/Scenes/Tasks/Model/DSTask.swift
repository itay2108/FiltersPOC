//
//  DSTask.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 12/02/2023.
//

import SwiftUI
import DSFilters

struct DSTask: Identifiable {
    
    var id: String {
        return UUID().uuidString
    }
    
    let title: String
    let deadline: Date
    let isFavorite: Bool
    let importance: TaskImportance
    
    enum TaskImportance: String, CaseIterable {
        case regular = "Regular"
        case important = "Important"
        case veryImportant = "Very Important"
        case urgent = "Urgent"
        
        var label: String? {
            switch self {
            case .regular:
                return nil
            case .important:
                return "!"
            case .veryImportant:
                return "!!"
            case .urgent:
                return "!!!"
            }
        }
        
        var labelColor: Color {
            switch self {
            case .regular:
                return .clear
            case .important, .veryImportant:
                return .blue
            case .urgent:
                return .red
            }
        }
    }
    
    static func placeholder() -> DSTask {
        let taskTitles = ["Write code", "Take a break", "Sprint Planning", "Fix Bugs"]
        return .init(title: taskTitles.randomElement() ?? "Do Stuff",
                     deadline: .now.addingDays(Int.random(in: 0...4)).addingHours(1),
                     isFavorite: .random(),
                     importance: .allCases.randomElement() ?? .regular)
    }
}

extension DSTask: Filterable {
    
    enum FilterKeys: String, FilterKey {
        case deadline = "deadline"
        case isFavorite = "favorite"
        case importance = "importance"
    }
    
    var filterDeadline: AnyEquatable {
        return deadline.daysLeftFromNowLocalized.anyEquatable
    }
    
    var filterFavorite: AnyEquatable {
        return (isFavorite ? "Yes" : "No").anyEquatable
    }
    
    var filterImportance: AnyEquatable {
        return importance.rawValue.anyEquatable
    }
    
    static func keypath(for key: String) -> KeyPath<DSTask, DSFilters.AnyEquatable>? {
        switch key {
        case FilterKeys.deadline.rawKey:
            return \.filterDeadline
        case FilterKeys.isFavorite.rawKey:
            return \.filterFavorite
        case FilterKeys.importance.rawKey:
            return \.filterImportance
        default:
            return nil
        }
    }
    
}

extension Array where Element == DSTask {
    func sortedByDeadline() -> [DSTask] {
        return self.sorted(by: { $0.deadline < $1.deadline })
    }
}


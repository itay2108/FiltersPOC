//
//  FilterCapsuleView.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 14/02/2023.
//

import SwiftUI
import DSFilters

struct FilterCapsuleView<T: Filterable>: View {
    
    let filter: Filter<T>
    var onDismiss: (() -> Void)? = nil
    
    var body: some View {
        
        visualContent()
            .foregroundColor(.background)
            .padding(.vertical, 8)
            .padding(.leading, 12)
            .padding(.trailing, 16)
            .background(
                Capsule()
                    .foregroundColor(.accentColor.opacity(0.9))
            )
    }
    
    @ViewBuilder
    func visualContent() -> some View {
        HStack {
            Image(systemName: "x.circle.fill")
                .font(.system(size: 11))
                .foregroundColor(.background)
                .onTapGesture {
                    onDismiss?()
                }
            
            Text("\(filter.rawKey.capitalized): \(filter.activeValuesStringArguments)")
                .font(.system(size: 14, weight: .medium))
        }
    }
}

struct FilterCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        FilterCapsuleView(filter: RawTaskFilters.main.filters.asFilters(for: DSTask.self).first!)
    }
}

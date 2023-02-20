//
//  FilterValuesView.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 13/02/2023.
//

import SwiftUI
import Filters

struct FilterValuesView<T: Filterable>: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: FilterValuesViewModel<T>
    
    @State var error: Error?
    
    var body: some View {
        
        ZStack {
            filterValueList(viewModel.filter)
                .padding(.top, 20)
                .ignoresSafeArea(edges: .bottom)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .overlay {
                    applyButton()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        titleView()
                    }
                }
            
            if error != nil {
                ErrorView(error: $error)
            }
        }
        .onReceive(viewModel.$error) { newError in
            self.error = newError
        }
    }
    
    @ViewBuilder
    private func titleView() -> some View {
        
        Text(viewModel.filter.rawKey.capitalized)
            .font(.system(size: 18, weight: .bold))
            .padding(.horizontal, 20)
            .padding(.top, 15)
    }
    
    @ViewBuilder
    private func filterValueList(_ filter: Filter<T>) -> some View {
        List(filter.values) { value in
            filterValueListItem(value.description,
                                isActive: filter.isValueActive(value))
                .onTapGesture {
                    Haptics.shared.vibrate(.soft)
                    viewModel.toggleValue(value)
                }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func filterValueListItem(_ value: String, isActive: Bool) -> some View {
        HStack {
            Text(value.capitalized)
                .font(.system(size: 18))
                .padding(.vertical, 12)
            Spacer()
            Image(systemName: isActive ? "circle.fill" : "circle")
        }
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private func applyButton() -> some View {
        VStack {
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Apply")
                    .foregroundColor(Color(uiColor: UIColor.systemBackground))
                    .font(.system(size: 20, weight: .medium))
                    .padding(.horizontal, 48)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .foregroundColor(.accentColor)
                    )
            }
        }
    }
}

struct FilterValuesView_Previews: PreviewProvider {
    static var previews: some View {
        FilterValuesView<DSTask>(viewModel: .init(filter: RawTaskFilters.main.filters.asFilters(for: DSTask.self).first!))
    }
}

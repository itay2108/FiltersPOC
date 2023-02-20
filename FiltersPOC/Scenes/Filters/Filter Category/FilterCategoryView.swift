//
//  FilterCategoryView.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 13/02/2023.
//

import SwiftUI
import Filters

struct FilterCategoryView<T: Filterable>: View {
    
    @StateObject var viewModel: FilterCategoryViewModel<T>
    
    @State var isShowingFilterValues: Bool = false
    @State var selectedFilter: Filter<T>?
    
    @State var error: Error? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                mainBody()
                
                if error != nil {
                    ErrorView(error: $error)
                }
            }
            .onReceive(viewModel.$error) { newError in
                self.error = newError
            }
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    func mainBody() -> some View {
        VStack {
            titleView()
            
            if let filterCategories = viewModel.filters {
                filterCategoryList(filterCategories)
            }
            navigationLinks()
        }
        .ignoresSafeArea(edges: .bottom)
        .overlay {
            resetButton()
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func titleView() -> some View {
        Text("\(String(describing: T.self)) Filters")
            .font(.system(size: 18, weight: .semibold))
            .padding(.horizontal, 20)
            .padding(.top, 10)
    }
    
    @ViewBuilder
    func filterCategoryList(_ filters: [Filter<T>]) -> some View {
        List(filters.sorted(by: { $0.rawKey < $1.rawKey })) { filter in
            filterCategoryListItem(filter)
                .onTapGesture {
                    selectedFilter = filter
                    isShowingFilterValues = true
                }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    func filterCategoryListItem(_ filter: Filter<T>) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(filter.rawKey.capitalized)
                    .font(.system(size: 20, weight: .medium))
                    .padding(.bottom, 10)
                Text(filter.activeValuesStringArguments)
                    .font(.system(size: 16))
                    .foregroundColor(.label.opacity(0.66))
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    func resetButton() -> some View {
        VStack {
            Spacer()
            
            Button {
                viewModel.resetFilters()
            } label: {
                Text("Reset")
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
    
    @ViewBuilder
    func navigationLinks() -> some View {
        NavigationLink(isActive: $isShowingFilterValues) {
            if let filter = selectedFilter {
                FilterValuesView(viewModel: .init(filter: filter, syncWith: viewModel))
            }
        } label: {
            EmptyView()
        }
        .hidden()
        .frame(width: .zero, height: .zero)
    }
}

struct FilterCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        FilterCategoryView<DSTask>(viewModel: .init(filters: RawTaskFilters.main.filters.asFilters(for: DSTask.self)))
    }
}

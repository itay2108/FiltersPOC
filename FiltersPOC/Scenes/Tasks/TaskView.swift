//
//  TaskView.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 12/02/2023.
//

import SwiftUI
import DSFilters

struct TaskView: View {
    
    @StateObject var viewModel: TaskViewModel = TaskViewModel()
    
    @State var isShowingFilters: Bool = false
    @State var error: Error?
    
    var body: some View {
        ZStack {
            mainBody()
            
            if error != nil {
                ErrorView(error: $error)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $isShowingFilters, content: {
            FilterCategoryView(viewModel: .init(syncWith: viewModel))
                .presentationDetents(viewModel.filterSheetHeights)
        })
        .onReceive(viewModel.$error) { newError in
            self.error = error
        }
    }
    
    @ViewBuilder
    func mainBody() -> some View {
        VStack {
            header()
            
            if let activeFilters = viewModel.activeFilters {
                activeFiltersView(activeFilters)
            }
            
            List(viewModel.relevantTasks) { task in
                TaskListItem(task: task)
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Text("Tasks")
                .font(.system(size: 30, weight: .bold))
                .padding(.top, 16)
            Spacer()
            
            Button {
                isShowingFilters.toggle()
            } label: {
                HStack {
                    Image(systemName: "slider.vertical.3")
                        .font(.system(size: 20, weight: .bold))
                        .offset(y: 7)
                        .foregroundColor(.label)
                }
                .frame(height: 20)
            }

        }
        .padding(.horizontal, 33)
    }
    
    @ViewBuilder
    func activeFiltersView(_ filters: [Filter<DSTask>]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filters) { filter in
                    FilterCapsuleView(filter: filter) {
                        viewModel.deactive(filter: filter)
                    }
                }
            }
            .padding(.leading, 30)
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}

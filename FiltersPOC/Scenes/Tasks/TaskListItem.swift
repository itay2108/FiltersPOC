//
//  TaskListItem.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 13/02/2023.
//

import SwiftUI

struct TaskListItem: View {
    
    let task: DSTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                titleLabel()
                deadlineLabel()
            }
            Spacer()
            starIcon()
                .frame(height: 18)
        }
        .contentShape(Rectangle())
        .padding(.horizontal)
    }
    
    
    @ViewBuilder
    func titleLabel() -> some View {
        HStack {
            Text(task.title)
                .font(.system(size: 18, weight: .medium))
            
            if let importanceLabel = task.importance.label {
                Text(importanceLabel)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(task.importance.labelColor)
            }
        }
    }
    
    @ViewBuilder
    func deadlineLabel() -> some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(.label.opacity(0.66))
            Text(task.deadline.daysLeftFromNowLocalized)
                .font(.system(size: 13, weight: .light))
                .padding(.top, 1)
        }
    }
    
    @ViewBuilder
    func starIcon() -> some View {
        if task.isFavorite {
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
        } else {
            Image(systemName: "star")
                .resizable()
                .scaledToFit()
        }
    }
}

struct TaskListItem_Previews: PreviewProvider {
    static var previews: some View {
        TaskListItem(task: .placeholder())
    }
}

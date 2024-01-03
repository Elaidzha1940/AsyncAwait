//  /*
//
//  Project: AsyncAwait
//  File: TaskGroupView.swift
//  Created by: Elaidzha Shchukin
//  Date: 03.01.2024
//
//  */

import SwiftUI

class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    
}

struct TaskGroupView: View {
    @StateObject private var viewModel = TaskGroupViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width: 180, height: 200)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Task Group 🥝")
        }
    }
}

#Preview {
    TaskGroupView()
}

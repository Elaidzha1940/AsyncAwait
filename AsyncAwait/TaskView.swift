//  /*
//
//  Project: AsyncAwait
//  File: TaskView.swift
//  Created by: Elaidzha Shchukin
//  Date: 02.01.2024
//
//  */

import SwiftUI

class TaskViewViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    func fetchImage() {
        
    }
}

struct TaskView: View {
    @StateObject private var viewModel = TaskViewViewModel()
    
    var body: some View {
        
        VStack {
            
        }
    }
}

#Preview {
    TaskView()
}

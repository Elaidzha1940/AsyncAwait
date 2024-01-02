//  /*
//
//  Project: AsyncAwait
//  File: AsyncAwaitView.swift
//  Created by: Elaidzha Shchukin
//  Date: 02.01.2024
//
//  */

import SwiftUI

class AsyncAwaitViewViewModel: ObservableObject {
    @Published var daraArray: [String] = []
    
    func addTitle1() {
        
    }
}

struct AsyncAwaitView: View {
    @StateObject private var viewModel = AsyncAwaitViewViewModel()
    
    var body: some View {
        
        List {
            ForEach(viewModel.daraArray, id: \.self) { data in
                Text(data)
            }
        }
    }
}

#Preview {
    AsyncAwaitView()
}

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.daraArray.append("Title1 : \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = ("Title2 : \(Thread.current)")
            DispatchQueue.main.async {
                self.daraArray.append(title)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1 : \(Thread.current)"
        self.daraArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2 : \(Thread.current)"
        self.daraArray.append(author2)
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
        .onAppear {
            Task {
               await viewModel.addAuthor1()
            }
//            viewModel.addTitle1()
//            viewModel.addTitle2()
        }
    }
}

#Preview {
    AsyncAwaitView()
}

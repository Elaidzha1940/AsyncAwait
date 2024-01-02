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
        
        // do this
        let author1 = "Author1 : \(Thread.current)"
        self.daraArray.append(author1)
        
        // wait 2 seconds
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // do all these
        let author2 = "Author2 : \(Thread.current)"
        await MainActor.run {
            self.daraArray.append(author2)
            
            let author3 = "Author3 : \(Thread.current)"
            self.daraArray.append(author3)
        }
        // then again wait
        await addSome()
    }
    
    func addSome() async {
        
        // wait 2 more seconds
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        // and then some1
        let some1 = "some1 : \(Thread.current)"
        await MainActor.run {
            self.daraArray.append(some1)
            // and last some2
            let some2 = "some2 : \(Thread.current)"
            self.daraArray.append(some2)
        }
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
                
                let finalText = "Final Text : \(Thread.current)"
                viewModel.daraArray.append(finalText)
            }
            //            viewModel.addTitle1()
            //            viewModel.addTitle2()
        }
    }
}

#Preview {
    AsyncAwaitView()
}

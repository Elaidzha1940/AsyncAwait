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
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://source.unsplash.com/random/300×400") else {
                return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Image returned successfully.")
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://source.unsplash.com/random/400×500") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
}

struct TaskHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Open it ✌🏻", destination: TaskView())
            }
        }
    }
}

struct TaskView: View {
    @StateObject private var viewModel = TaskViewViewModel()
    @State private var fetchImageTask:  Task<(), Never>? = nil
    
    var body: some View {
        
        VStack(spacing: 20) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15 )
                    .frame(width: 350, height: 450)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15 )
                    .frame(width: 350, height: 450)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
        
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
        
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
//            
//            //            Task {
//            ////                print(Thread.current)
//            ////                print(Task.currentPriority)
//            //                await viewModel.fetchImage2()
//            //            }
//            
//            //            Task(priority: .high) {
//            //               //try? await Task.sleep(nanoseconds: 2_000_000_000)
//            //                await Task.yield()
//            //                print("high : \(Thread.current) : \(Task.currentPriority)")
//            //            }
//            //            Task(priority: .userInitiated) {
//            //                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//            //            }
//            //            Task(priority: .medium) {
//            //                print("medium : \(Thread.current) : \(Task.currentPriority)")
//            //            }
//            //            Task(priority: .low) {
//            //                print("low : \(Thread.current) : \(Task.currentPriority)")
//            //            }
//            //            Task(priority: .utility) {
//            //                print("utility : \(Thread.current) : \(Task.currentPriority)")
//            //            }
//            //            Task(priority: .background) {
//            //                print("background : \(Thread.current) : \(Task.currentPriority)")
//            //            }
//            
//            //            Task(priority: .userInitiated) {
//            //                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//            //
//            //                Task.detached  {
//            //                    print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//            //                }
//            //            }
//            
//        }
    }
}

#Preview {
    TaskView()
}

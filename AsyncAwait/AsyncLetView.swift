//  /*
//
//  Project: AsyncAwait
//  File: AsyncLetView.swift
//  Created by: Elaidzha Shchukin
//  Date: 03.01.2024
//
//  */

import SwiftUI

struct AsyncLetView: View {
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://source.unsplash.com/random/300×400")!
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let 😎")
            .onAppear {
                Task {
                    
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) =  try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

#Preview {
    AsyncLetView()
}

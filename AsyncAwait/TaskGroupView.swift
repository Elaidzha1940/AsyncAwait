//  /*
//
//  Project: AsyncAwait
//  File: TaskGroupView.swift
//  Created by: Elaidzha Shchukin
//  Date: 03.01.2024
//
//  */

import SwiftUI

class TaskGroupDataManager {
    
    func fetchImagesAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: "https://source.unsplash.com/random/300×500/?animals")
        async let fetchImage2 = fetchImage(urlString: "https://source.unsplash.com/random/300×500/?animals")
        async let fetchImage3 = fetchImage(urlString: "https://source.unsplash.com/random/300×500/?animals")
        async let fetchImage4 = fetchImage(urlString: "https://source.unsplash.com/random/300×500/?animals")
        async let fetchImage5 = fetchImage(urlString: "https://source.unsplash.com/random/300×500/?animals")
        async let fetchImage6 = fetchImage(urlString: "https://source.unsplash.com/random/300×500/?animals ")

        let (image1, image2, image3, image4, image5, image6) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4, try fetchImage5, try fetchImage6)
        
        return [image1, image2, image3, image4, image5, image6]
    }
    
    
    
   private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
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

class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupDataManager()
    
    
    func getImages() async {
        if let iamges = try? await manager.fetchImagesAsyncLet() {
            self.images.append(contentsOf: images)
        }
    }
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
            .navigationTitle("Animals 🥝")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

#Preview {
    TaskGroupView()
}

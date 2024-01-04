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
        async let fetchImage1 = fetchImage(urlString: "https://source.unsplash.com/random/300×400")
        async let fetchImage2 = fetchImage(urlString: "https://source.unsplash.com/random/300×400")
        async let fetchImage3 = fetchImage(urlString: "https://source.unsplash.com/random/300×400")
        async let fetchImage4 = fetchImage(urlString: "https://source.unsplash.com/random/300×400")
  
        
        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlStrings = [
            "https://source.unsplash.com/random/300×400",
            "https://source.unsplash.com/random/300×400",
            "https://source.unsplash.com/random/300×400",
            "https://source.unsplash.com/random/300×400",
            "https://source.unsplash.com/random/300×400",
        ]
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count)
            
            for urlStrings in urlStrings {
                group.addTask {
                    try? await self.fetchImage(urlString: urlStrings)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
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
//        if (try? await manager.fetchImagesWithTaskGroup()) != nil {
        if let iamges = try? await manager.fetchImagesWithTaskGroup() {
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
                            .frame(width: 300, height: 400)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Animals 🐻")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

#Preview {
    TaskGroupView()
}

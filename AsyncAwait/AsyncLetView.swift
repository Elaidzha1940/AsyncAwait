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
    let url = URL(string: "https://source.unsplash.com/random/300×500/?fruis")!
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width: 180, height: 200)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Fruits 🥝")
            .onAppear {
                Task {
                    do {
                        
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        async let fetchImage5 = fetchImage()
                        async let fetchImage6 = fetchImage()
                        
                        let (image1, image2, image3, image4, image5, image6) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4, try fetchImage5, try fetchImage6)
                        self.images.append(contentsOf: [image1, image2, image3, image4, image5, image6])
                        
                        //                        let image1 = try await fetchImage()
                        //                        self.images.append(image1)
                        //
                        //                        let image2 = try await fetchImage()
                        //                        self.images.append(image2)
                        //
                        //                        let image3 = try await fetchImage()
                        //                        self.images.append(image3)
                        //
                        //                        let image4 = try await fetchImage()
                        //                        self.images.append(image4)
                        //
                        //                        let image5 = try await fetchImage()
                        //                        self.images.append(image5)
                        //
                        //                        let image6 = try await fetchImage()
                        //                        self.images.append(image6)
                        
                    } catch {
                        
                    }
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

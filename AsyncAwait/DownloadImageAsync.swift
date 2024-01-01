//  /*
//
//  Project: AsyncAwait
//  File: DownloadImageAsync.swift
//  Created by: Elaidzha Shchukin
//  Date: 01.01.2024
//
//  */

/*
// Async/Await
// @escaping
// Combine
*/

import SwiftUI

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    func fetchImage() {
        self.image = UIImage(systemName: "person")
    }
}

class DownloadImageAsyncImageLoader: ObservableObject {
    
    let url = URL(string: "https://github.com/unsplash/unsplash-photopicker-ios.git")!
    
    func dowloadWithEscaping() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                    let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                return
            }
        }
        .resume()
    }
}

struct DownloadImageAsync: View {
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(15)
            }
        }
        .onAppear {
            viewModel.fetchImage()
        }
    }
}

#Preview {
    DownloadImageAsync()
}

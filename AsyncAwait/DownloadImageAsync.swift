//  /*
//
//  Project: AsyncAwait
//  File: DownloadImageAsync.swift
//  Created by: Elaidzha Shchukin
//  Date: 01.01.2024
//
//  */

/*
 // Swift Concurrency
 
 // Async/Await
 // @escaping
 // Combine
 */

import SwiftUI

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    
    func fetchImage() {
        loader .dowloadWithEscaping { [weak self] image, error in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}

class DownloadImageAsyncImageLoader {
    
    let url = URL(string: "https://source.unsplash.com/random/300×400")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func dowloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
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
                    .cornerRadius(15)
                    .frame(width: 300, height: 400)
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

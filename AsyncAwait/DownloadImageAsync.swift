//  /*
//
//  Project: AsyncAwait
//  File: DownloadImageAsync.swift
//  Created by: Elaidzha Shchukin
//  Date: 01.01.2024
//
//  */

// Swift Concurrency
/*
 
 // Async/Await
 // @escaping
 // Combine
 */

import SwiftUI
import Combine

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    var cancellables = Set<AnyCancellable>()
    
    func fetchImage() async {
        
        /*
        //MARK: @escaping
        
        //        loader .dowloadWithEscaping { [weak self] image, error in
        //
        //        }
        
        //MARK: Combine
        
//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                
//            } receiveValue: { [weak self] image in
//                self?.image = image
//            }
//            .store(in: &cancellables )
         */
        
        //MARK: Async/Await
       let image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
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
    
    //MARK: @escaping

    func dowloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
    
    //MARK: Combine

    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    //MARK: Async/Await

    func downloadWithAsync() async throws -> UIImage? {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
         } catch {
            throw error
        }
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
            Task {
               await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadImageAsync()
}

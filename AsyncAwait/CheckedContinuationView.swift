//  /*
//
//  Project: AsyncAwait
//  File: CheckedContinuationView.swift
//  Created by: Elaidzha Shchukin
//  Date: 04.01.2024
//
//  */

import SwiftUI

class CheckedContinuationNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getPersonImageFromDataBase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completionHandler(UIImage(systemName: "person.fill")!)
        }
    }
    
    func getPersonImageFromDataBase() async -> UIImage {
        await withCheckedContinuation { continuation in
            getPersonImageFromDataBase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://source.unsplash.com/random/300×400") else { return }
        
        do {
            let data = try await networkManager.getData2(url: url)
            
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error)
        }
    }
    
//    func getPersonImage() {
//        networkManager.getPersonImageFromDataBase { [weak self] image in
//            self?.image = image
//        }
//    }
    
    func getPersonImage() async {
        self.image = await networkManager.getPersonImageFromDataBase()
    }
}

struct CheckedContinuationView: View {
    @StateObject private var viewModel = CheckedContinuationViewModel()
    
    var body: some View {
        
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .frame(width: 200, height: 300)
            }
        }
        .task {
            //            await viewModel.getImage()
            await viewModel.getPersonImage()
        }
    }
}

#Preview {
    CheckedContinuationView()
}

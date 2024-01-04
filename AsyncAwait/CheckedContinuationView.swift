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
       return try await withCheckedContinuation { continuation in
           URLSession.shared.dataTask(with: url) { data, response, error in
               if let data = data {
                   continuation.resume(returning: data)
               }
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
           let data = try await networkManager.getData(url: url)
            
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error)
        }
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
            await viewModel.getImage()
        }
    }
}

#Preview {
    CheckedContinuationView()
}

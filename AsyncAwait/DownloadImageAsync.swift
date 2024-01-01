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
    }
}

#Preview {
    DownloadImageAsync()
}

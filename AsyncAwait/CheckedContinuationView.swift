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
    
}

class CheckedContinuationViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    func getImage() async {
        
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

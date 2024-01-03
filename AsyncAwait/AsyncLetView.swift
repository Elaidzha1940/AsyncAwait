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
    @State private var image: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    
                }
            }
        }
    }
}

#Preview {
    AsyncLetView()
}

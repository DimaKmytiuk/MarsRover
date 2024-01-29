//
//  ImageView.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import SwiftUI

struct ImageLoaderView: View {
    
    @StateObject var viewModel: ImageLoaderViewModel
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: (image))
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .cornerRadius(25)
        } else {
            ProgressView()
                .frame(width: 130, height: 130)
                .onAppear(perform: viewModel.loadImage)
            
        }
    }
    
}

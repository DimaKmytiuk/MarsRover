//
//  ImageLoaderViewModel.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import SwiftUI

final class ImageLoaderViewModel: ObservableObject {
    
    @Published var image: UIImage?
    let url: String
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    init(image: UIImage? = nil, url: String) {
        self.image = image
        self.url = url
    }
    
    func loadImage() {
        if let cachedImage = getFromCache(name: url) {
            self.image = cachedImage

            return
        }
        
        guard let imageURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                    self.addToCache(image: uiImage, name: self.url)
                }
            }
        }.resume()
    }

    
    private func addToCache(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
    }
    
    private func getFromCache(name: String) -> UIImage? {
        guard let image = imageCache.object(forKey: name as NSString) else {
            return nil
        }
        return image
    }
    
}

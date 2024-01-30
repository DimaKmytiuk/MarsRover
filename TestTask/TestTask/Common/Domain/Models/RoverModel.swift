//
//  RoverModel.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 23.01.2024.
//

import UIKit

struct RoverModel: Identifiable {
    let id = UUID()
    let name: String
    let camera: String
    let date: String
    let imageSRC: String
    var image: UIImage?
    
    init(
        name: String,
        camera: String,
        date: String,
        imageSRC: String
    ) {
        self.name = name
        self.camera = camera
        self.date = date
        self.imageSRC = imageSRC
    }
}

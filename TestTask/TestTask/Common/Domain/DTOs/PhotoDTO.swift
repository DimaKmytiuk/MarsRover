//
//  PhotoDTO.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import Foundation

struct PhotoArrayDTO: Codable {
    let photos: [PhotoDTO]
}

struct PhotoDTO: Codable {
    let id: Int
    let sol: Int
    let camera: CameraDTO
    let img_src: String
    let earth_date: String
    let rover: RoverDTO
    
}

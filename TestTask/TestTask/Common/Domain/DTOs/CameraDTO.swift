//
//  CameraDTO.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import Foundation

struct CameraDTO: Codable {
    let id: Int
    let name: String
    let rover_id: Int
    let full_name: String
}

struct CameraArrayDTO: Codable {
    let name: String
    let full_name: String
}

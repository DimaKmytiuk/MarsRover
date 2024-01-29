//
//  FilterModel.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import Foundation

struct FilterModel: Identifiable {
    var id = UUID()
    let rover: String
    let camera: String
    let date: String
}

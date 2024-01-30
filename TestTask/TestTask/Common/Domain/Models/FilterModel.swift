//
//  FilterModel.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import Foundation

struct FilterModel: Identifiable {
    let id = UUID()
    var rover: String
    var camera: String
    var date: Date
}

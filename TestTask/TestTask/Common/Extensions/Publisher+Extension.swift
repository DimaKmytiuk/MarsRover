//
//  Publisher+Extension.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import Combine

typealias VoidNeverPublisher = AnyPublisher<Void, Never>

extension Publisher where Failure == Never {
    static var never: AnyPublisher<Output, Failure> {
        Empty(completeImmediately: false).eraseToAnyPublisher()
    }
}

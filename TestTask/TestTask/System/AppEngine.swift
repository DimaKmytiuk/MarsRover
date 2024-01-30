//
//  AppEngine.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 29.01.2024.
//

import SwiftUI

final class AppEngine: ObservableObject {
    
    enum State {
        case launch
        case launched
    }
    
    @Published private var engineState: State = .launch
    
    func startEngine() {
        //for example load some data
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.engineState = .launched
        }
    }
    
    func checkAppEngineState() -> State {
        engineState
    }
}

//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 19.01.2024.
//

import SwiftUI

@main
struct TestTaskApp: App {
    
    @StateObject private var appEngine: AppEngine = AppEngine()
    private let environment: AppEnvironment
    
    init() {
        environment = AppEnvironment.bootstrap()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch appEngine.checkAppEngineState() {
                case .launch:
                    LaunchView()
                        .onAppear {
                            appEngine.startEngine()
                        }
                case .launched:
                    RootView(viewModel: .init(container: environment.container))
                }
            }
        }
    }
}

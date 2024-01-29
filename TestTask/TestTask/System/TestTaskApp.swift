//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 19.01.2024.
//

import SwiftUI

@main
struct TestTaskApp: App {
    
    private var environment: AppEnvironment
    @State private var showLaunchView = true
    
    init() {
        environment = AppEnvironment.bootstrap()

    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if showLaunchView {
                    LaunchView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showLaunchView.toggle()
                                }
                        }
                } else {
                    RootView(viewModel: .init(container: environment.container))
                }
            }
        }
    }
}

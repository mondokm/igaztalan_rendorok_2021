//
//  ITSecurityHWApp.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import SwiftUI

@main
struct ITSecurityHWApp: App {
//    private let basePath = "https://desolate-scrubland-75908.herokuapp.com"
//    private let basePath = "http://mondokm.sch.bme.hu:8080"
    private let basePath = "http://217.197.189.128:8080"
    private lazy var userStore: UserStoreProtocol = UserService()

    init() {
        DependencyInjector.registerDependencies()
        SwaggerClientAPI.basePath = basePath
    }

    @ObservedObject var appState = AppState()
    var body: some Scene {
        WindowGroup {
            if !appState.hasAuthenticated {
                OpeningView(loginViewModel: LoginViewModel())
                    .environmentObject(appState)
            } else {
                MainView(mainViewModel: MainViewModel())
            }
        }
    }
}

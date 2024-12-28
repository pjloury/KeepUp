// KeepUpApp.swift
import SwiftUI

@main
struct KeepUpApp: App {
    @State private var isShowingLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        // Dismiss launch screen after a delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingLaunchScreen = false
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}

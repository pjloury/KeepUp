// Updated ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    
    var body: some View {
        NavigationView {
            switch gameManager.gameState {
            case .home:
                HomeView(gameManager: gameManager)
                    .onAppear {
                        AudioManager.shared.startBackgroundMusic()
                    }
            case .playing:
                GameplayView(gameManager: gameManager)
                    .onAppear {
                        AudioManager.shared.stopBackgroundMusic()
                    }
            case .gameOver:
                GameOverView(gameManager: gameManager)
            case .countdown:
                CountdownView(gameManager: gameManager)
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            AudioManager.shared.startBackgroundMusic()
        }
    }

}

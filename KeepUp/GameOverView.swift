import SwiftUI

// GameOverView.swift
struct GameOverView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 30) {
            Text(gameManager.gameOverMessage) // Error was here
                .font(.system(size: 60, design: .rounded))
                .fontWeight(.heavy)
                .foregroundStyle(KeepUpColors.titleGradient)
            
            Text("Score: \(gameManager.score)")
                .font(.gameFont(size: 32))
                //.foregroundStyle(KeepUpColors.titleGradient)
                .foregroundColor(.white)
            
            Text("PLAY AGAIN?")
                .font(.gameFont(size: 24))
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                Button("YES") {
                    gameManager.startCountdown()
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(Color.green)
                .cornerRadius(25)
                
                Button("NO") {
                    gameManager.resetGame()
                }
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(Color.red)
                .cornerRadius(10)
                .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(KeepUpColors.backgroundGradient)
    }
}

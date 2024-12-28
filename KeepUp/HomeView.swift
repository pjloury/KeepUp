import SwiftUI
// Updated HomeView.swift
struct HomeView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 30) {
            Text("KEEP UP!")
                .font(.system(size: 70, design: .rounded))
                .fontWeight(.heavy)
                .foregroundStyle(KeepUpColors.titleGradient)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
            
            Button(action: {
                gameManager.startCountdown()
            }) {
                Text("Start Game")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(KeepUpColors.buttonGradient)
                    .cornerRadius(25)
                    .shadow(radius: 5)
            }
            
            Text("High Score: \(gameManager.highScore)")
                .font(.title2)
                .foregroundColor(.white)
            
            DifficultySelector(difficulty: $gameManager.difficulty)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(KeepUpColors.backgroundGradient)
    }
}

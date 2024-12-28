import SwiftUI

// CountdownView.swift
struct CountdownView: View {
    @ObservedObject var gameManager: GameManager
    @State private var scale: CGFloat = 1.0
    @State private var offsetX: CGFloat = 0.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        VStack {
            if gameManager.currentCountdownText == "Keep Up!" {
                Text(gameManager.currentCountdownText)
                    .font(.system(size: 72, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundStyle(KeepUpColors.titleGradient)
                    .scaleEffect(scale)
                    .offset(x: offsetX)
                    .opacity(opacity)
            } else {
                Text(gameManager.currentCountdownText)
                    .font(.system(size: 72, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(.purple)
                    .scaleEffect(scale)
                    .offset(x: offsetX)
                    .opacity(opacity)
            }
        }
        .onChange(of: gameManager.currentCountdownText) { newText in
            // Reset animation states
            scale = 1.0
            offsetX = 0.0
            opacity = 1.0
            
            if newText != "Keep Up!" {
                // Trembling effect for numbers
                withAnimation(
                    .easeInOut(duration: 0.05)
                    .repeatCount(8, autoreverses: true)
                ) {
                    offsetX = 3  // Small, quick horizontal trembles
                }
                
                // Zoom and fade after trembling for numbers
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeIn(duration: 0.6)) {
                        scale = 2.5
                        opacity = 0
                    }
                }
            } else {
                // Only zoom and fade for "Keep Up!", no trembling
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 0.8)) {
                        scale = 2.5
                        opacity = 0
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(KeepUpColors.backgroundGradient)
    }
}
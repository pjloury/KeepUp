import SwiftUI
// GameplayView.swift
struct GameplayView: View {
    @ObservedObject var gameManager: GameManager
    @State private var scale: CGFloat = 0.5 // Start smaller for pop-in effect
    @State private var animationOpacity: Double = 0.0 // Start invisible
    
    var body: some View {
        VStack {
            Text("Reaction Time: \(String(format: "%.1f", gameManager.reactionTime)) ms")
                .font(.caption)
                .foregroundColor(KeepUpColors.darkBlue)
                .padding(.top)
            
            Text("\(gameManager.currentDirection.rawValue)")
                .font(.system(size: 70, design: .rounded))
                .fontWeight(.heavy)
                .foregroundStyle(KeepUpColors.darkYellow)
                .scaleEffect(scale)
                .opacity(animationOpacity)
                .onAppear {
                    // Trigger initial animation
                    animateDirection()
                }
                .onChange(of: gameManager.currentDirection) { _ in
                    animateDirection()
                }
            
            Text("Score: \(gameManager.score)")
                .font(.gameFont(size: 24))
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(KeepUpColors.backgroundGradient)
        .gesture(
            DragGesture()
                .onEnded { value in
                    let direction: GameManager.Direction
                    
                    if value.translation.width < -50 {
                        direction = .left
                    } else if value.translation.width > 50 {
                        direction = .right
                    } else if value.translation.height < -50 {
                        direction = .up
                    } else if value.translation.height > 50 {
                        direction = .down
                    } else {
                        return
                    }
                    
                    gameManager.handleSwipe(direction: direction)
                }
        )
    }
    
    private func animateDirection() {
        // Reset animation states
        scale = 0.5
        animationOpacity = 0.0
        
        // Pop in with spring animation
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
            scale = 1.2 // Overshoot slightly
            animationOpacity = 1.0
        }
        
        // Settle to final size
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                scale = 1.0
            }
        }
    }
}

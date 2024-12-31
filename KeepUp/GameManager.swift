// Updated GameManager.swift
import SwiftUI
import Combine
import AVFoundation


enum GameDifficulty: String, CaseIterable {
    case easy = "EASY"
    case medium = "MEDIUM"
    case hard = "HARD"
    
    var responseTime: Double {
        switch self {
        case .easy: return 1.8
        case .medium: return 1.5
        case .hard: return 1.0
        }
    }
}


// GameManager.swift update - make sure these properties are properly published:
class GameManager: ObservableObject {
    @Published var gameState: GameState = .home
    @Published var currentDirection: Direction = .left
    @Published var score: Int = 0
    @Published var highScore: Int = UserDefaults.standard.integer(forKey: "KeepUpHighScore")
    @Published var gameOverMessage: String = ""
    @Published var currentCountdownText: String = ""
    
    @Published var reactionTime: Double = 0.0 // in milliseconds
    private var audioPlayer: AVAudioPlayer?
    
    @Published var difficulty: GameDifficulty = .medium

    private var lastGameOverMessage: String = ""
    private let gameOverMessages = [
        "OH SNAP!",
        "NOT TODAY!",
        "WHOOPSIE!",
        "TOO SLOW!",
        "YIKES!",
        "NICE TRY!",
        "SERIOUSLY?!",
        "OOPS-A-DAISY!",
        "MEH...",
        "BETTER LUCK!"
    ]
    

    private var timer: Timer?
    private var directionTimer: Timer?
    private var reactionTimer: Timer?
    private var reactionStartTime: Date?
    private var respondInTime: Double = 1.5
    
    enum GameState {
        case home, playing, countdown, gameOver
    }
    
    enum Direction: String, CaseIterable {
        case left = "LEFT!"
        case right = "RIGHT!"
        case up = "UP!"
        case down = "DOWN!"
        case singleTap = "Single tap!"
        case doubleTap = "Double tap!"
        case zoomIn = "Zoom in!"
        case zoomOut = "Zoom out!"
        
        var audioFile: String {
            switch self {
            case .left: return "swipe-left"
            case .right: return "swipe-right"
            case .up: return "swipe-up"
            case .down: return "swipe-down"
            case .singleTap: return "single-tap"
            case .doubleTap: return "double-tap"
            case .zoomIn: return "zoom-in"
            case .zoomOut: return "zoom-out"
            }
        }
    }

    private var tapTimer: Timer?
    private var firstTapTime: Date?
    private var isWaitingForSecondTap = false
    private let doubleTapTimeThreshold: TimeInterval = 0.3 // Maximum time between taps
    
    init() {
        // Setup audio session to allow playing sounds
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
    }
    
    func startCountdown() {
        gameState = .countdown
        let countdownNumbers = ["3", "2", "1", "Keep Up!"]
        var index = 0
        currentCountdownText = countdownNumbers[index]
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            index += 1
            if index < countdownNumbers.count {
                self.currentCountdownText = countdownNumbers[index]
                
                // If we've shown "Keep Up!", wait a bit longer before starting gameplay
                if countdownNumbers[index] == "Keep Up!" {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { // Increased delay
                        self.startGameplay()
                    }
                }
            } else {
                timer.invalidate()
                self.startGameplay()
            }
        }
    }
    
    private func startGameplay() {
        score = 0
        reactionTime = 0.0
        gameState = .playing
        chooseRandomDirection()
    }
    
    func chooseRandomDirection() {
        currentDirection = Direction.allCases.randomElement()!
        startReactionTimeTracking()
        
        // Play the direction sound
        AudioManager.shared.playDirectionSound(currentDirection)
        
        // Set a timer to end the game if no response in time
        directionTimer?.invalidate() // Cancel any existing timer
        
        let timeLimit = difficulty.responseTime
        directionTimer = Timer.scheduledTimer(withTimeInterval: timeLimit, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            if self.currentDirection == .doubleTap && self.isWaitingForSecondTap {
                // Don't end game yet if we're waiting for second tap and still have time
                return
            }
            self.endGame()
        }
    }
    
    func startReactionTimeTracking() {
        reactionStartTime = Date()
        reactionTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.reactionStartTime else { return }
            self.reactionTime = abs(startTime.timeIntervalSinceNow) * 1000 // Convert to milliseconds
        }
    }
    
    func stopReactionTimeTracking() {
        reactionTimer?.invalidate()
        reactionTimer = nil
    }
    

        
    func playBoopSound() {
        guard let path = Bundle.main.path(forResource: "boop", ofType: "wav") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not play sound file: \(error)")
        }
    }
    
    
    func handleSwipe(direction: Direction) {
        // If we're expecting a tap, this is wrong
        if currentDirection == .singleTap || currentDirection == .doubleTap {
            endGame()
            return
        }
        
        // Stop reaction time tracking
        stopReactionTimeTracking()
        
        // Invalidate the direction timer
        directionTimer?.invalidate()
        
        if direction == currentDirection {
            handleCorrectAction()
        } else {
            endGame()
        }
    }
    
    func getRandomGameOverMessage() -> String {
           var availableMessages = gameOverMessages
           // Remove the last shown message to avoid repetition
           if let lastIndex = availableMessages.firstIndex(of: lastGameOverMessage) {
               availableMessages.remove(at: lastIndex)
           }
           
           // Pick a random message from remaining options
           let newMessage = availableMessages.randomElement()!
           lastGameOverMessage = newMessage
           return newMessage
       }
    
    func endGame() {
        directionTimer?.invalidate()
        stopReactionTimeTracking()
        
        // Play game over sound
        AudioManager.shared.playGameOverSound()
        
        // Set new random game over message
        gameOverMessage = getRandomGameOverMessage()
        
        // Update high score if needed
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "KeepUpHighScore")
        }
        
        gameState = .gameOver
    }
    
    func resetGame() {
        gameState = .home
    }
    
    func handleTap() {
        if currentDirection == .singleTap {
            // For single tap, we can immediately validate
            handleCorrectAction()
        } else if currentDirection == .doubleTap {
            if isWaitingForSecondTap {
                // This is the second tap
                if let firstTime = firstTapTime {
                    // Valid double tap
                    handleCorrectAction()
                }
                resetTapState()
            } else {
                // This is the first tap
                firstTapTime = Date()
                isWaitingForSecondTap = true
                
                // Don't set a separate timer for double tap - we'll use the main direction timer
            }
        } else {
            // Tapped when should have swiped
            endGame()
        }
    }
    
    private func resetTapState() {
        isWaitingForSecondTap = false
        firstTapTime = nil
        tapTimer?.invalidate()
        tapTimer = nil
    }
    
    private func handleCorrectAction() {
        // Stop reaction time tracking
        stopReactionTimeTracking()
        
        // Invalidate the direction timer
        directionTimer?.invalidate()
        
        // Play boop sound on correct action
        AudioManager.shared.playBoopSound()
        
        score += 1
        
        // Add a small delay before playing the next direction to ensure sounds don't overlap
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.chooseRandomDirection()
        }
    }
    
    func handlePinch(scale: CGFloat) {
        // If we're not expecting a zoom gesture, this is wrong
        if currentDirection != .zoomIn && currentDirection != .zoomOut {
            endGame()
            return
        }
        
        // For zoom in, scale should be > 1, for zoom out, scale should be < 1
        let isZoomingIn = scale > 1
        let isZoomingOut = scale < 1
        
        if (currentDirection == .zoomIn && isZoomingIn) || 
           (currentDirection == .zoomOut && isZoomingOut) {
            handleCorrectAction()
        } else {
            endGame()
        }
    }
}

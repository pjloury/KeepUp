import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var gameOverPlayer: AVAudioPlayer?
    private var directionPlayers: [String: AVAudioPlayer] = [:]
    
    // Pool of audio players for boop sound
    private var boopPlayers: [AVAudioPlayer] = []
    private var currentBoopIndex = 0
    private let boopPoolSize = 3  // Number of players in the pool
    
    private init() {
        setupAudioSession()
        setupAudioPlayers()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func setupAudioPlayers() {
        setupBoopSoundPool()
        setupGameOverSound()
        setupBackgroundMusic()
        setupDirectionSounds()
    }
    
    private func setupBoopSoundPool() {
        guard let path = Bundle.main.path(forResource: "boop", ofType: "wav") else {
            print("Boop sound file not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        // Create pool of players
        for _ in 0..<boopPoolSize {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                boopPlayers.append(player)
            } catch {
                print("Could not create boop player: \(error)")
            }
        }
    }
    
    private func setupGameOverSound() {
        guard let path = Bundle.main.path(forResource: "game-over", ofType: "wav") else {
            print("Game over sound file not found")
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            gameOverPlayer = try AVAudioPlayer(contentsOf: url)
            gameOverPlayer?.prepareToPlay()
        } catch {
            print("Could not prepare game over sound: \(error)")
        }
    }
    
    private func setupBackgroundMusic() {
        guard let path = Bundle.main.path(forResource: "keep-up-home-screen", ofType: "mp3") else {
            print("Background music file not found")
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Infinite loop
            backgroundMusicPlayer?.prepareToPlay()
        } catch {
            print("Could not prepare background music: \(error)")
        }
    }
    
    private func setupDirectionSounds() {
        let directions = ["swipe-up", "swipe-down", "swipe-left", "swipe-right", 
                         "single-tap", "double-tap", "zoom-in", "zoom-out"]
        
        for direction in directions {
            guard let path = Bundle.main.path(forResource: direction, ofType: "mp3") else {
                print("\(direction) sound file not found")
                continue
            }
            
            do {
                let url = URL(fileURLWithPath: path)
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                directionPlayers[direction] = player
            } catch {
                print("Could not create \(direction) player: \(error)")
            }
        }
    }
    
    func playBoopSound() {
        // Get next available player from the pool
        let player = boopPlayers[currentBoopIndex]
        
        // If this player is still playing, stop it
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
        
        player.play()
        
        // Move to next player in pool
        currentBoopIndex = (currentBoopIndex + 1) % boopPoolSize
    }
    
    func playGameOverSound() {
        gameOverPlayer?.play()
    }
    
    func startBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer?.currentTime = 0
    }
    
    func playDirectionSound(_ direction: GameManager.Direction) {
        if let player = directionPlayers[direction.audioFile] {
            if player.isPlaying {
                player.stop()
                player.currentTime = 0
            }
            player.play()
        }
    }
}

//
//  DifficultySelector.swift
//  KeepUp
//
//  Created by PJ Loury on 11/28/24.
//

import SwiftUI

// Create a new DifficultySelector.swift
struct DifficultySelector: View {
    @Binding var difficulty: GameDifficulty
    
    var body: some View {
        VStack(spacing: 10) {
            Text("DIFFICULTY:")
                .font(.gameFont(size: 24))
                .foregroundStyle(KeepUpColors.titleGradient)
            
            HStack(spacing: 15) {
                ForEach(GameDifficulty.allCases, id: \.self) { level in
                    Button(action: {
                        difficulty = level
                    }) {
                        Text(level.rawValue)
                            .font(.gameFont(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(difficulty == level ? .white : .gray)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(
                                difficulty == level ?
                                KeepUpColors.darkYellow :
                                    Color.gray.opacity(0.2)
                            )
                            .cornerRadius(15)
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

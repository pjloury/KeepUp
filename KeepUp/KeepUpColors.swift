//
//  KeepUpColor.swift
//  KeepUp
//
//  Created by PJ Loury on 11/28/24.
//

import SwiftUI

// Create a ColorScheme struct to store our app colors
struct KeepUpColors {
    static let darkYellow = Color(red: 0.91, green: 0.79, blue: 0.28)

    static let yellowOrange = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let hotPink = Color(red: 0.89, green: 0.4, blue: 0.79)
    static let neonBlue = Color(red: 0.47, green: 0.98, blue: 0.99)
    static let darkBlue = Color(red: 0.0, green: 0.0, blue: 0.8)
    static let limeGreen = Color(red: 0.58, green: 0.83, blue: 0.26)
    
    
    // Gradient presets
    static let titleGradient = LinearGradient(
        gradient: Gradient(colors: [yellowOrange, limeGreen]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Gradient presets
    static let subtitleGradient = LinearGradient(
        gradient: Gradient(colors: [yellowOrange, limeGreen]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    
    // Gradient presets
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [yellowOrange, orange, hotPink]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [neonBlue, hotPink]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let background2Gradient = LinearGradient(
        gradient: Gradient(colors: [neonBlue.opacity(0.2), darkBlue.opacity(0.3)]),
        startPoint: .topTrailing,
        endPoint: .bottomLeading
    )
}

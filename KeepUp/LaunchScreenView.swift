//
//  LaunchScreenView.swift
//  KeepUp
//
//  Created by PJ Loury on 11/28/24.
//

import SwiftUI

// LaunchScreenView.swift
struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            KeepUpColors.darkYellow // Or your app's background color
            
            VStack {
                // Your app logo/icon
                Image("logo") // Add your logo to Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
        }
        .ignoresSafeArea()
    }
}

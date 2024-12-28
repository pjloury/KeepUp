//
//  FontExtension.swift
//  KeepUp
//
//  Created by PJ Loury on 11/28/24.
//

import SwiftUI

// 3. Create a Font extension for easy usage:

extension Font {
    static func comicFont(size: CGFloat) -> Font {
        return .custom("Bangers-Regular", size: size)
    }
    static func gameFont(size: CGFloat) -> Font {
            return .custom("Fredoka", size: size)
    }
}

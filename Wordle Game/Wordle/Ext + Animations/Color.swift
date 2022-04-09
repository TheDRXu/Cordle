//
//  Color.swift
//  WordleGame
//
//  Created by Dwayne Reinaldy on 3/30/22.
//
import SwiftUI

extension Color {
    static var wrong: Color {
        Color(red: 229/255, green: 228/255, blue: 221/255)
    }
    static var misplaced: Color {
        Color(red: 241/255, green: 207/255, blue: 188/255)
    }
    static var correct: Color {
        Color(red: 192/255, green: 237/255, blue: 188/255)
    }
    static var unused: Color {
        Color(red: 236/255, green: 234/255, blue: 187/255)
    }
    static var systemBackground: Color {
        Color(.systemBackground)
    }
}

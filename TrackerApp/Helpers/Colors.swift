//
//  Colors.swift
//  TrackerApp
//
//  Created by Эмилия on 08.01.2024.
//

import UIKit

enum Color {
    
    static let blackDay = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified: return UIColor(hexString: "#1A1B22")
        case .dark: return UIColor(hexString: "#FFFFFF")
        }
    }
    
    static let whiteDay = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified: return UIColor(hexString: "#FFFFFF")
        case .dark: return UIColor(hexString: "#1A1B22")
        }
    }
    
    static let backgroundDay = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified: return UIColor(hexString: "#30E6E8EB")
        case .dark: return UIColor(hexString: "#85414141")
        }
    }
    
    static let tabBarColor = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified: return UIColor(hexString: "#E6E8EB")
        case .dark: return UIColor(hexString: "#000000")
        }
    }
    
    static let datePickerColor = UIColor(hexString: "#F0F0F0")
    
    static let black = UIColor(hexString: "#1A1B22")
    static let white = UIColor(hexString: "#FFFFFF")
    static let gray = UIColor(hexString: "#AEAFB4")
    static let lightGray = UIColor(hexString: "#E6E8EB")
    
    static let red = UIColor(hexString: "#F56B6C")
    static let blue = UIColor(hexString: "#3772E7")
    
    static let active = blue
    static let inActive = gray
    
    static let colorSelection1 = UIColor(hexString: "#FD4C49")
    static let colorSelection2 = UIColor(hexString: "#FF881E")
    static let colorSelection3 = UIColor(hexString: "#007BFA")
    static let colorSelection4 = UIColor(hexString: "#6E44FE")
    static let colorSelection5 = UIColor(hexString: "#33CF69")
    static let colorSelection6 = UIColor(hexString: "#E66DD4")
    
    static let colorSelection7 = UIColor(hexString: "#F9D4D4")
    static let colorSelection8 = UIColor(hexString: "#34A7FE")
    static let colorSelection9 = UIColor(hexString: "#46E69D")
    static let colorSelection10 = UIColor(hexString: "#35347C")
    static let colorSelection11 = UIColor(hexString: "#FF674D")
    static let colorSelection12 = UIColor(hexString: "#FF99CC")
    
    static let colorSelection13 = UIColor(hexString: "#F6C48B")
    static let colorSelection14 = UIColor(hexString: "#7994F5")
    static let colorSelection15 = UIColor(hexString: "#832CF1")
    static let colorSelection16 = UIColor(hexString: "#AD56DA")
    static let colorSelection17 = UIColor(hexString: "#8D72E6")
    static let colorSelection18 = UIColor(hexString: "#2FD058")
}

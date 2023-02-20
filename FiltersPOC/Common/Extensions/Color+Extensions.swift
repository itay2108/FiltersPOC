//
//  Color+Extensions.swift
//  FiltersPOC
//
//  Created by Itay Gervash on 14/02/2023.
//

import SwiftUI

extension Color {
    
    static var label: Color {
        let uiColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return .black
            }
        }
        return Color(uiColor: uiColor)
    }
    
    static var background: Color {
        return Color(uiColor: UIColor.systemBackground)
    }
}

//
//  Haptics.swift
//  Dior Retail App
//
//  Created by Itay Gervash on 26/01/2023.
//  Copyright © 2023 Balink. All rights reserved.
//

import UIKit

class Haptics {
    static let shared = Haptics()
    
    private init() { }

    func vibrate(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}

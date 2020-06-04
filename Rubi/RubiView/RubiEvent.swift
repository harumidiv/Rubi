//
//  RubiEvent.swift
//  Rubi
//
//  Created by 佐川 晴海 on 2020/06/04.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import Foundation

enum RubiEvent: Hashable {
    enum Load {
        case refresh
        case success
        case error
    }
    
    enum Transition {
        case voiceRecognition
        case handwriting
        case characterRecognition
    }
    
    case load(Load)
    case transition(Transition)
}

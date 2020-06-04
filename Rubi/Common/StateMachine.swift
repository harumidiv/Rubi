//
//  StateMachine.swift
//  Rubi
//
//  Created by 佐川 晴海 on 2020/06/04.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import Foundation

struct Transition<S: Hashable, E: Hashable> {
    let from: S
    let to: S
    let by: E
    let withAction: (() -> Void)?
}

class StateMachine<S: Hashable, E: Hashable> {

    private(set) var state: S

    private var routes: [S: [E: (S, (() -> Void)?)]] = [:]

    init(initialState: S, transitions: [Transition<S, E>]) {
        state = initialState
        for transition in transitions {
            var dictionary = routes[transition.from] ?? [:]
            dictionary[transition.by] = (transition.to, transition.withAction)
            routes[transition.from] = dictionary
        }
    }

    func fire(by: E) -> S? {
        guard let (nextState, completion) = routes[state].flatMap({ $0[by] }) else {
            return nil
        }
        state = nextState
        completion?()
        return state
    }
}

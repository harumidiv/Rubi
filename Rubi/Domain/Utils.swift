//
//  Utils.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/30.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Reachability

final class Network {
    
    static func isOnline() -> Bool {
        guard let reachability = Reachability() else { return false }
        return reachability.connection != .none
    }
    
}

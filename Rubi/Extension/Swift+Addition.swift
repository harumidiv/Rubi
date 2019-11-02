//
//  Swift+Addition.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/29.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// メインスレッドの場合は同期的に実行し、それ以外の場合はメインスレッドで実行するようにスケジューリングします
func runOnMain(block: @escaping () -> Void) {
    guard Thread.isMainThread else {
        DispatchQueue.main.async {
            runOnMain(block: block)
        }
        return
    }
    block()
}

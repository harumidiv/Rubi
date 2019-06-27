//
//  Rubi.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/27.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

struct Rubi:Codable {
    var request_id: String
    var output_type: String
    var converted: String
}

struct PostData: Codable {
    var app_id:String
    var sentence: String
    var output_type: String
}

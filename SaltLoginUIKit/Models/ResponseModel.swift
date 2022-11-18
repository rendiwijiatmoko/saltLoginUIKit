//
//  ResponseModel.swift
//  SaltLoginUIKit
//
//  Created by Rendi Wijiatmoko on 18/11/22.
//

import Foundation

struct ResponseModel: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    init(token: String) {
        self.token = token
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)
    }
}

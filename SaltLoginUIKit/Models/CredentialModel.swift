//
//  CredentialModel.swift
//  SaltLoginUIKit
//
//  Created by Rendi Wijiatmoko on 18/11/22.
//

import Foundation

struct CredentialModel: Encodable {
    var email: String = ""
    var password: String = ""
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
    
    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
    }
}

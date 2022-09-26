//
//  EventDTO.swift
//  OOTD
//
//  Created by taekki on 2022/09/27.
//

import Foundation

struct EventDTO: Codable {
    let type: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case createdAt = "created_at"
    }
}

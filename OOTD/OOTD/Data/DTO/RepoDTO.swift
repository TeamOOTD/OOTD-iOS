//
//  RepoDTO.swift
//  OOTD
//
//  Created by taekki on 2022/09/27.
//

import Foundation

struct RepoDTO: Codable {
    let name: String?
    let fullName: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
    }
}

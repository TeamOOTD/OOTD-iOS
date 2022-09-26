//
//  APIEnvironment.swift
//  OOTD
//
//  Created by taekki on 2022/09/27.
//

import Foundation

enum APIEnvironment: String {
    case development
}

extension APIEnvironment {
    var baseURL: String {
        switch self {
        case .development:
            return "https://api.github.com"
        }
    }
    
    var token: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
}

//
//  GitHubEndPoint.swift
//  OOTD
//
//  Created by taekki on 2022/09/27.
//

import Foundation

enum GitHubEndPoint {
    case fetchUser(username: String)
    case fetchRepos(username: String)
    case fetchEvents(username: String)
}

extension GitHubEndPoint: EndPoint {
    var method: HttpMethod {
        switch self {
        case .fetchUser, .fetchRepos, .fetchEvents:
            return .GET
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchUser, .fetchRepos, .fetchEvents:
            return nil
        }
    }
    
    func getURL(from environment: APIEnvironment) -> String {
        let baseURL = environment.baseURL
        switch self {
        case .fetchUser(let username):
            return "\(baseURL)/users/\(username)"
        case .fetchRepos(let username):
            return "\(baseURL)/users/\(username)/repos"
        case .fetchEvents(let username):
            return "\(baseURL)/users/\(username)/events?per_page=100"
        }
    }
}

//
//  GitHubManager.swift
//  OOTD
//
//  Created by taekki on 2022/09/27.
//

import Foundation

struct GitHubManager {
    private let apiService: Requestable
    private let environment: APIEnvironment
    
    init(apiService: Requestable, environment: APIEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }
    
    func fetchUser(for username: String) async throws -> UserDTO? {
        let request = GitHubEndPoint
            .fetchUser(username: username)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
    
    func fetchRepos(for username: String) async throws -> [RepoDTO]? {
        let request = GitHubEndPoint
            .fetchRepos(username: username)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
    
    func fetchEvents(for username: String) async throws -> [EventDTO]? {
        let request = GitHubEndPoint
            .fetchEvents(username: username)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
}

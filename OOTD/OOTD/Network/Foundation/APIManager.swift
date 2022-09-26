//
//  APIManager.swift
//  OOTD
//
//  Created by taekki on 2022/09/27.
//

import Foundation

protocol Requestable: AnyObject {
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> T?
}

final class APIManager: Requestable {
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> T? {
        guard let encodedURL = request.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL) else {
            throw APIError.urlEncodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request.createURLRequest(with: url))
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<500) ~= httpResponse.statusCode else {
            throw APIError.serverError
        }

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}

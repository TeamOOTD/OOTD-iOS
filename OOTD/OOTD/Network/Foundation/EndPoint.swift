//
//  EndPoint.swift
//  OOTD
//
//  Created by taekki on 2022/09/27.
//

import Foundation

protocol EndPoint {
    var method: HttpMethod { get }
    var body: Data? { get }
    
    func getURL(from environment: APIEnvironment) -> String
    func createRequest(environment: APIEnvironment) -> NetworkRequest
}

extension EndPoint {
    func createRequest(environment: APIEnvironment) -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["accesstoken"] = environment.token
        return NetworkRequest(url: getURL(from: environment),
                              httpMethod: method,
                              requestBody: body,
                              headers: headers)
    }
}

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

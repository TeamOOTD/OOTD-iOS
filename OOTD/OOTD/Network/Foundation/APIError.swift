//
//  APIError.swift
//  OOTD
//
//  Created by taekki on 2022/09/27.
//

import Foundation

enum APIError: Error {
    case urlEncodingError
    case clientError(message: String?)  // 4XX
    case serverError                    // 5XX
}

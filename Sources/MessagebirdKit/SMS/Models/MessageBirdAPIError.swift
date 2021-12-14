//
//  MessageBirdAPIError.swift
//  
//
//  Created by Andrew Edwards on 12/11/21.
//

import Foundation

public struct MessageBirdAPIError: Error, Codable {
    /// An integer that represents the error type.
    public var code: MessageBirdAPIErrorCode
    /// A human-readable description of the error. You can provide your users with this information to indicate what they can do about the error.
    public var description: String
    /// The parameter in your request that is related to the error if the error is parameter specific.
    public var parameter: String?
}

public enum MessageBirdAPIErrorCode: Int, Codable {
    case requestNotAllowed = 2
    case missingParams = 9
    case invalidParams = 10
    case notFound = 20
    case badRequest = 21
    case notEnoughBalance = 25
    case apiNotFound = 98
    case internalError = 99
    case serviceUnavailable = 100
    case duplicateEntry = 101
    case ambiguousLookup = 102
}

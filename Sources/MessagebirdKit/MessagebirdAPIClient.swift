//
//  MessagebirdAPIClient.swift
//  
//
//  Created by Andrew Edwards on 12/12/21.
//

import Foundation
import AsyncHTTPClient
import NIOHTTP1
import NIOFoundationCompat
import NIO

enum MessagebirdAPIEndpoint {
    case sendMessage
    case getMessages
    case getMessage(String)
    case deleteMessage(String)
    
    var url: String {
        switch self {
        case .sendMessage, .getMessages:
            return "https://rest.messagebird.com/messages"
        case .getMessage(let message):
            return "https://rest.messagebird.com/messages/\(message)"
        case .deleteMessage(let message):
            return "https://rest.messagebird.com/messages\(message)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendMessage:
            return .POST
        case .getMessages, .getMessage(_):
            return .GET
        case .deleteMessage(_):
            return .DELETE
        }
    }
}

public class MessagebirdAPIClient {
    private var httpClient: HTTPClient
    private var accessKey: String
    private var decoder: JSONDecoder
    
    public init(client: HTTPClient, accessKey: String) {
        self.httpClient = client
        self.accessKey = accessKey
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(RFC3339DateFormatter)
        self.decoder = decoder
    }
    
    public func setAccessKey(key: String) {
        self.accessKey = key
    }
    
    public func setDecoder(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func send<M: Codable>(path: MessagebirdAPIEndpoint,
                          body: HTTPClient.Body = .string(""),
                          query: String = "") async throws -> M {
        let request = try HTTPClient.Request(url: "\(path.url)?\(query)",
                                             method: path.method,
                                             headers: ["Authorization": "AccessKey \(accessKey)"],
                                             body: body)
           
        let response = try await httpClient.execute(request: request).get()
        
        guard let byteBuffer = response.body else {
            throw MessageBirdAPIError(code: .internalError, description: "No response from messagebird API for request \("\(path.url)?\(query)")", parameter: nil)
        }
        
        let responseData = Data(byteBuffer.readableBytesView)
        
        guard response.status == .ok else {
            throw try decoder.decode(MessageBirdAPIError.self, from: responseData)
        }
        return try decoder.decode(M.self, from: responseData)
    }
}

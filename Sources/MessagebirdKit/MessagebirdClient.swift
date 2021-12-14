//
//  MessagebirdClient.swift
//  
//
//  Created by Andrew Edwards on 12/12/21.
//

import Foundation
import AsyncHTTPClient

public class MessagebirdClient {
    public var sms: SMSRoutes
    let apiClient: MessagebirdAPIClient
    
    init(client: HTTPClient, accessKey: String) {
        apiClient = MessagebirdAPIClient(client: client, accessKey: accessKey)
        sms = SMSRoutes(client: apiClient)
    }
}

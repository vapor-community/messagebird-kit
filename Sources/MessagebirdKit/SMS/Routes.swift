//
//  Routes.swift
//  
//
//  Created by Andrew Edwards on 12/12/21.
//

import Foundation

public struct SMSRoutes {
    let client: MessagebirdAPIClient
    init(client: MessagebirdAPIClient) {
        self.client = client
    }
    
    /// Send an SMS message
    /// - Parameters:
    ///   - originator: The sender of the message. This can be a telephone number (including country code) or an alphanumeric string. In case of an alphanumeric string, the maximum length is 11 characters.
    ///   - body: The body of the SMS message.
    ///   - recipients: An array of recipients msisdns.
    ///   - groupIds: An array of group id's. If provided recipients can be omitted.
    ///   - type: The type of message. Values can be: `sms`, `binary`, or `flash`.
    ///   - reference: A client reference.
    ///   - reportUrl: The status report URL to be used on a per-message basis. `reference` is required for a status report webhook to be sent.
    ///   - validity: The amount of seconds that the message is valid. If a message is not delivered within this time, the message will be discarded.
    ///   - gateway: The SMS route that is used to send the message.
    ///   - typeDetails: A hashmap with extra information. Is only used when a binary message is sent.
    ///   - datacoding: The datacoding used can be plain (GSM 03.38 characters only), unicode (contains non-GSM 03.38 characters) or auto, we will then set unicode or plain depending on the body content.
    ///   - mclass: Indicated the message type. 1 is a normal message, 0 is a flash message. (0-3 are valid values)
    ///   - shortenUrls: `private beta` Shorten all the URLs present in the message body.
    ///   - scheduledDatetime: The scheduled date and time of the message in RFC3339 format
    ///   - createdDatetime: The date and time of the creation of the message in RFC3339 format
    /// - Returns: The created `Message`
    public func send(originator: String,
                     body: String,
                     recipients: [String],
                     groupIds: [String]? = nil,
                     type: MessageType? = nil,
                     reference: String? = nil,
                     reportUrl: String? = nil,
                     validity: Int? = nil,
                     gateway: Int? = nil,
                     typeDetails: [String: Any]? = nil,
                     datacoding: String? = nil,
                     mclass: Int? = nil,
                     shortenUrls: Bool? = nil,
                     scheduledDatetime: String? = nil,
                     createdDatetime: String? = nil) async throws -> Message {
        
        var body: [String: Any] = ["originator": originator,
                                   "body": body,
                                   "recipients": recipients]
    
        if let groupIds = groupIds {
            body["groupIds"] = groupIds
        }
        
        if let type = type {
            body["type"] = type.rawValue
        }
        
        if let reference = reference {
            body["reference"] = reference
        }
        
        if let reportUrl = reportUrl {
            body["reportUrl"] = reportUrl
        }
        
        if let validity = validity {
            body["validity"] = validity
        }
        
        if let gateway = gateway {
            body["gateway"] = gateway
        }
        
        if let typeDetails = typeDetails {
            typeDetails.forEach { body["typeDetails[\($0)]"] = $1 }
        }
        
        if let datacoding = datacoding {
            body["datacoding"] = datacoding
        }
        
        if let mclass = mclass {
            body["mclass"] = mclass
        }
        
        if let shortenUrls = shortenUrls {
            body["shortenUrls"] = shortenUrls
        }
        
        if let scheduledDatetime = scheduledDatetime {
            body["scheduledDatetime"] = scheduledDatetime
        }
        
        if let createdDatetime = createdDatetime {
            body["createdDatetime"] = createdDatetime
        }
        
        let data = try JSONSerialization.data(withJSONObject: body, options: [])
        
        return try await client.send(path: .sendMessage, body: .data(data), query: "")
    }
    
    /// Retrieve information of an existing inbound or outbound SMS message
    /// - Parameter id: The unique message id
    /// - Returns: The `Message`
    func get(id: String) async throws -> Message {
        try await client.send(path: .getMessage(id))
    }
    
    
    /// List all inbound and outbound SMS messages
    /// - Parameters:
    ///   - originator: Display messages by the specified originator.
    ///   - recipient: Display messages for the specified recipient.
    ///   - direction: Display either `mt` (sent) or `mo` (received) messages.
    ///   - limit: Limit the amount of messages listed.
    ///   - offset: Skip first `n` results.
    ///   - searchterm: Display messages including the specified searchterm in recipient and originator
    ///   - type: type descriptionDisplay messages of type `sms`, `binary`, or `flash`
    ///   - contactId: Display messages by `contact_id`. See Contacts API for more info.
    ///   - status: Display messages with status `scheduled`, `sent`, `buffered`, `delivered`, `expired`, or `delivery_failed`.
    ///   - from: Display messages starting from the specified date in RFC3339 format.
    ///   - until: Display messages until the specified date in RFC3339 format.
    /// - Returns: A list of filtered messages.
    func getAll(originator: String? = nil,
                recipient: String? = nil,
                direction: MessageDirection? = nil,
                limit: Int? = nil,
                offset: Int? = nil,
                searchterm: String? = nil,
                type: MessageType? = nil,
                contactId: Int? = nil,
                status: MessageRecipientItemStatus? = nil,
                from: String? = nil,
                until: String? = nil) async throws -> MessageList {
        
        var body: [String: Any] = [:]
        
        if let originator = originator {
            body["originator"] = originator
        }
        
        if let recipient = recipient {
            body["recipient"] = recipient
        }
        
        if let direction = direction {
            body["direction"] = direction.rawValue
        }
        
        if let limit = limit {
            body["limit"] = limit
        }
        
        if let offset = offset {
            body["offset"] = offset
        }
        
        if let searchterm = searchterm {
            body["searchterm"] = searchterm
        }
        
        if let type = type {
            body["type"] = type.rawValue
        }
        
        if let contactId = contactId {
            body["contact_id"] = contactId
        }
        
        if let status = status {
            body["status"] = status.rawValue
        }
        
        if let from = from {
            body["from"] = from
        }
        
        if let until = until {
            body["until"] = until
        }
        
        return try await client.send(path: .getMessages, query: body.queryParameters)
    }
    
    /// List all scheduled SMS messages
    /// - Returns: A list of messages
    func getScheduled() async throws -> MessageList {
        try await client.send(path: .getMessages, query: "status=scheduled")
    }
}

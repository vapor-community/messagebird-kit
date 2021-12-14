//
//  Message.swift
//  
//
//  Created by Andrew Edwards on 12/6/21.
//

import Foundation

public struct Message: Codable {
    /// A unique random ID which is created on the MessageBird platform and is returned upon creation of the object.
    public var id: String
    /// The URL of the created object.
    public var href: String
    /// Tells you if the message is sent or received.
    public var direction: MessageDirection?
    /// The type of message. Values can be: `sms`, `binary`, or `flash`
    public var type: MessageType
    /// The sender of the message. This can be a telephone number (including country code) or an alphanumeric string. In case of an alphanumeric string, the maximum length is 11 characters. You can set a [default originator](https://dashboard.messagebird.com/settings/sms?_gl=1*188qt0h*_ga*MTU4NzM2MTkwMC4xNjM4NzcwOTYy*_ga_5YJ7WT147X*MTYzOTI3NTIzOC45LjEuMTYzOTI3NTcyNi4w) in your account or use `inbox` to use the [Sticky VMN](https://developers.messagebird.com/api/sms-messaging#sticky-vmn) feature.
    public var originator: String?
    /// The body of the SMS message.
    public var body: String
    /// A client reference.
    public var reference: String?
    /// The status report URL to be used on a per-message basis. `reference` is required for a status report webhook to be sent.
    public var reportUrl: String?
    /// The amount of seconds that the message is valid. If a message is not delivered within this time, the message will be discarded.
    public var validity: Int?
    /// The SMS route that is used to send the message.
    public var gateway: Int?
    /// A hashmap with extra information.
    public var typeDetails: [String: String]
    /// The datacoding used, defaults to plain (GSM 03.38 characters only), or it can be set to unicode (contains non-GSM 03.38 characters) or set to auto and we will set unicode or plain depending on the body content.
    public var datacoding: String
    /// Indicated the message type. 1 is a normal message, 0 is a flash message. (0-3 are valid values)
    public var mclass: Int
    /// The scheduled date and time of the message in RFC3339 format (Y-m-d\TH:i:sP)
    public var scheduledDatetime: Date?
    /// The date and time of the creation of the message in RFC3339 format (Y-m-d\TH:i:sP)
    public var createdDatetime: Date
    /// The hashmap with recipient information. Further explanation in the table below.
    public var recipients: MessageRecipient
}

public enum MessageDirection: String, Codable {
    /// mobile terminated (sent to mobile)
    case mt
    /// mobile originated (received from mobile)
    case mo
}

public enum MessageType: String, Codable {
    case sms
    case binary
    case flash
}

public struct MessageRecipient: Codable {
    /// The total count of recipients.
    public var totalCount: Int
    /// The count of recipients that have the message pending (status `sent`, and `buffered`).
    public var totalSentCount: Int
    /// The count of recipients where the message is delivered (status `delivered`).
    public var totalDeliveredCount: Int
    /// The count of recipients where the delivery has failed (status `delivery_failed`).
    public var totalDeliveryFailedCount: Int
    /// An array of recipient hashmaps.
    public var items: [MessageRecipientItem]
}

public struct MessageRecipientItem: Codable {
    /// The msisdn of the recipient
    public var recipient: Int
    /// The status of the message sent to the recipient. Possible values: `scheduled`, `sent`, `buffered`, `delivered`, `expired`, and `delivery_failed`.
    public var status: MessageRecipientItemStatus
    /// The datum time of the last status in RFC3339 format (Y-m-d\TH:i:sP)
    public var statusDatetime: Date
    /// The count of total messages send. Personalisation not taken in account.
    public var messagePartCount: Int
    /// The name of the recipient’s original country, based on MSISDN.
    public var recipientCountry: String?
    /// The prefix code for the recipient’s original country, based on MSISDN.
    public var recipientCountryPrefix: Int?
    /// The name of the operator of the recipient. Identified by MCCMNC of the message.
    public var recipientOperator: String?
    /// The length of the message in characters. Depends on the message datacoding.
    public var messageLength: Int
    /// The details about the message status. Possible values: `successfully delivered`, `pending DLR`, `DLR not received`, `incorrect number`, `unknown subscriber`, `expired`, `timeout`, and `generic delivery failure`.
    public var statusReason: MessageRecipientItemStatusReason
    /// A hashmap with extra information about how much the message costs.
    public var price: MessageRecipientItemPrice?
    /// The code of the operator of the message sender. It could have null value if the message isn’t delivered yet.
    public var mccmnc: String?
    /// The MCC (Mobile Country Code) part of MCCMNC.
    public var mcc: String?
    /// The MNC (Mobile Network Code) part of MCCMNC.
    public var mnc: String?
}

public enum MessageRecipientItemStatus: String, Codable {
    case scheduled
    case sent
    case buffered
    case delivered
    case expired
    case deliveryFailed = "delivery_failed"
}

public enum MessageRecipientItemStatusReason: String, Codable {
    case successfullyDelivered = "successfully delivered"
    case pendingDLR = "pending DLR"
    case dlrNotReceived = "DLR not received"
    case incorrectNumber = "incorrect number"
    case unknownSubscriber = "unknown subscriber"
    case expired
    case timeout
    case genericDeliveryFailure = "generic delivery failure"
}

public struct MessageRecipientItemPrice: Codable {
    /// The price the message was billed with. It could have a null value if the message isn’t billed yet.
    public var amount: Float?
    /// The alphabetic code of the price currency, in ISO 4217 format. It could have null value if the message isn’t billed yet.
    public var currency: String?
}

public struct MessageList: Codable {
    public var offset: Int
    public var limit: Int
    public var count: Int
    public var totalCount: Int
    public var links: MessageListLinks
    public var items: [Message]
}

public struct MessageListLinks: Codable {
    public var first: String?
    public var previous: String?
    public var next: String?
    public var last: String?
}

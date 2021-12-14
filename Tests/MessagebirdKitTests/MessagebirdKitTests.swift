import XCTest
@testable import MessagebirdKit

final class messagebird_kitTests: XCTestCase {
    func testMessageListDecoding() throws {
        let data = """
{
    "offset": 0,
    "limit": 20,
    "count": 4,
    "totalCount": 4,
    "links": {
        "first": "https://rest.messagebird.com/messages/?offset=0",
        "previous": null,
        "next": null,
        "last": "https://rest.messagebird.com/messages/?offset=0"
    },
    "items": [
        {
            "id": "436d780b854749b4beca51623d9e2674",
            "href": "https://rest.messagebird.com/messages/436d780b854749b4beca51623d9e2674",
            "direction": "mt",
            "type": "sms",
            "originator": "YourName",
            "body": "This is a test message",
            "reference": null,
            "validity": null,
            "gateway": 10,
            "typeDetails": {},
            "datacoding": "plain",
            "mclass": 1,
            "scheduledDatetime": null,
            "createdDatetime": "2020-02-04T19:01:12+00:00",
            "recipients": {
                "totalCount": 1,
                "totalSentCount": 1,
                "totalDeliveredCount": 0,
                "totalDeliveryFailedCount": 1,
                "items": [
                    {
                        "recipient": 31612345678,
                        "originator": null,
                        "status": "delivery_failed",
                        "statusDatetime": "2020-02-04T19:01:12+00:00",
                        "recipientCountry": "Netherlands",
                        "recipientCountryPrefix": 31,
                        "recipientOperator": "",
                        "messageLength": 22,
                        "statusReason": "incorrect number",
                        "price": {
                            "amount": null,
                            "currency": null
                        },
                        "mccmnc": null,
                        "mcc": null,
                        "mnc": null,
                        "messagePartCount": 1
                    }
                ]
            }
        }
    ]
}
""".data(using: .utf8)!
        
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(RFC3339DateFormatter)

        
        let _ = try decoder.decode(MessageList.self, from: data)
    }
}

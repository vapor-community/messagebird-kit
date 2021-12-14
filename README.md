# MessagebirdKit
![](https://img.shields.io/badge/Swift-5.5-lightgrey.svg?style=svg)
![](https://img.shields.io/badge/SwiftNio-2-lightgrey.svg?style=svg)
![Test](https://github.com/vapor-community/messagebird-kit/workflows/Test/badge.svg)

### MessagebirdKit is a swift package used to communicate with the [Messagebird](https://www.messagebird.com/en/) API

## Requirements
MessagebirdKit requires swift 5.5 and macOS 12 Monterey ans supports async await.

## Installation
To start using MessagebirdKit, in your `Package.swift`, add the following
```swift
.package(url: "https://github.com/vapor-community/messagebird-kit.git", from: "1.0.0")
```
 
## Usage
You'll need an `HTTPClient` and your access key to crerate a `MessagebirdClient`.
```swift
let httpClient = HTTPClient(...)
let messagebird = MessagebirdClient(client: httpClient, accessKey: "test_1234")
```

You now have access to using any associated API on the client.

```swift
let response = try await messagebird.sms.send(originator: "Swift",
                                              body: "Get ready for world domination!",
                                              recipients: ["12223334567"])
```

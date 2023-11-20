//
//  WMDelayedScrollLink.swift
//  RoxChatMobileWidget
//
//

import Foundation

class WMDelayedScrollLink: Equatable {
    var creationTime = Date().timeIntervalSince1970
    var messageId: String

    init(messageId: String) {
        self.messageId = messageId
    }

    static func == (lhs: WMDelayedScrollLink, rhs: WMDelayedScrollLink) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

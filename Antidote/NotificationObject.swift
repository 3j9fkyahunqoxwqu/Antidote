// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

enum NotificationAction {
    case OpenChat(chatUniqueIdentifier: String)
    case OpenRequest(requestUniqueIdentifier: String)
    case AnswerIncomingCall(userInfo: String)
}

extension NotificationAction {
    private struct Constants {
        static let ValueKey = "ValueKey"
        static let ArgumentKey = "ArgumentKey"

        static let OpenChatValue = "OpenChatValue"
        static let OpenRequestValue = "OpenRequestValue"
        static let AnswerIncomingCallValue = "AnswerIncomingCallValue"
    }

    init?(dictionary: [String: String]) {
        guard let value = dictionary[Constants.ValueKey] else {
            return nil
        }

        switch value {
            case Constants.OpenChatValue:
                guard let argument = dictionary[Constants.ArgumentKey] else {
                    return nil
                }
                self = OpenChat(chatUniqueIdentifier: argument)
            case Constants.OpenRequestValue:
                guard let argument = dictionary[Constants.ArgumentKey] else {
                    return nil
                }
                self = OpenRequest(requestUniqueIdentifier: argument)
            case Constants.AnswerIncomingCallValue:
                guard let argument = dictionary[Constants.ArgumentKey] else {
                    return nil
                }
                self = AnswerIncomingCall(userInfo: argument)
            default:
                return nil
        }
    }

    func archive() -> [String: String] {
        switch self {
            case .OpenChat(let identifier):
                return [
                    Constants.ValueKey: Constants.OpenChatValue,
                    Constants.ArgumentKey: identifier,
                ]
            case .OpenRequest(let identifier):
                return [
                    Constants.ValueKey: Constants.OpenRequestValue,
                    Constants.ArgumentKey: identifier,
                ]
            case .AnswerIncomingCall(let userInfo):
                return [
                    Constants.ValueKey: Constants.AnswerIncomingCallValue,
                    Constants.ArgumentKey: userInfo,
                ]
        }
    }
}

struct NotificationObject {
    /// Title of notification
    let title: String

    /// Body text of notification
    let body: String

    /// Action to be fired when user interacts with notification
    let action: NotificationAction

    /// Sound to play when notification is fired. Valid only for local notifications.
    let soundName: String
}

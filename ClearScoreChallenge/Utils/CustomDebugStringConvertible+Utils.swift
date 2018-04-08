//  Copyright © 2018 Edgar Antunes. All rights reserved.

import Foundation

/* This helper extension makes it simple to dump
 * Encodable instances in lldb, with pretty formatting.
 */
public extension CustomDebugStringConvertible where Self: Encodable {
    public var debugDescription: String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        guard let data = try? jsonEncoder.encode(self), let json = try? JSONSerialization.jsonObject(with: data) else {
            return ""
        }

        return "\(json)"
    }
}

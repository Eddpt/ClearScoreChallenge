//  Copyright © 2018 Edgar Antunes. All rights reserved.

import Foundation

public protocol Parser {
    func parse<T: Decodable>(_ data: Data) throws -> T
}

public final class JSONParser: Parser {
    private let jsonDecoder = JSONDecoder()

    public init() {}

    public func parse<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

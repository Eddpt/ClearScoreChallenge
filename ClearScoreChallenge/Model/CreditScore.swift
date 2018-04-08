//  Copyright © 2018 Edgar Antunes. All rights reserved.

import Foundation

struct CreditScore: Codable, CustomDebugStringConvertible {
    let creditReportInfo: CreditReportInfo
}

struct CreditReportInfo: Codable, CustomDebugStringConvertible {
    let score: Int
    let maxScoreValue: Int
}

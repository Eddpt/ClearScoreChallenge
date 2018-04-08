//  Copyright © 2018 Edgar Antunes. All rights reserved.

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

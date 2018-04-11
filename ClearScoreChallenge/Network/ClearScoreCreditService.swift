//  Copyright © 2018 Edgar Antunes. All rights reserved.

import Foundation

protocol CreditService {
    typealias Completion = ((Result<CreditScore>) -> Void)

    @discardableResult
    func fetchCredit(completion: @escaping Completion) -> URLSessionDataTask?
}

final class ClearScoreCreditService: CreditService {
    enum Error: Swift.Error {
        case badResponse(URLResponse?)
        case networkError(String?)
        case parsing
    }

    private let session: URLSession
    private let parser: Parser

    public init(session: URLSession = URLSession.shared, parser: Parser = JSONParser()) {
        self.session = session
        self.parser = parser
    }

    @discardableResult
    func fetchCredit(completion: @escaping Completion) -> URLSessionDataTask? {
        let task = session.dataTask(with: Configuration.clearScoreBaseURL) { data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(Error.networkError(error?.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                200 ... 299 ~= httpResponse.statusCode else {
                completion(.failure(Error.badResponse(response)))
                return
            }

            guard let creditScore: CreditScore = try? self.parser.parse(data) else {
                completion(.failure(Error.parsing))
                return
            }

            completion(.success(creditScore))
        }

        task.resume()

        return task
    }
}

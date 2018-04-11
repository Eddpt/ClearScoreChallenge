//  Copyright © 2018 Edgar Antunes. All rights reserved.

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    public override init() {}
    public override func resume() {}
    public override func suspend() {}
    public override func cancel() {}
    public override var state: State {
        return .suspended
    }
}

class MockURLSession: URLSession {
    let responseData: Data?
    let responseError: Error?
    let statusCode: Int

    convenience init(responseFile: String?, responseError: Error? = nil, statusCode: Int = 200) {
        var responseData: Data?
        if let url = Bundle(for: MockURLSession.self).url(forResource: responseFile, withExtension: "json") {
            responseData = try? Data(contentsOf: url, options: .mappedIfSafe)
        }

        self.init(responseData: responseData, responseError: responseError, statusCode: statusCode)
    }

    init(responseData: Data?, responseError: Error? = nil, statusCode: Int = 200) {
        self.responseData = responseData
        self.responseError = responseError
        self.statusCode = statusCode
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> MockURLSessionDataTask {
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "", headerFields: nil)
        DispatchQueue.global().async {
            completionHandler(self.responseData, response, self.responseError)
        }

        return MockURLSessionDataTask()
    }
}

//  Copyright © 2018 Edgar Antunes. All rights reserved.

@testable import ClearScoreChallenge
import XCTest

class ClearScoreCreditServiceTests: XCTestCase {
    let invalidResponseData = """
    {
        "a": "b",
        "c": "c"
    }
    """.data(using: .utf8)

    func test_clearScoreCreditService_500() {
        let responseError = ClearScoreCreditService.Error.networkError(nil)
        let mockSession = MockURLSession(responseFile: nil, responseError: responseError, statusCode: 500)
        let service: CreditService = ClearScoreCreditService(session: mockSession)
        let expectation = self.expectation(description: "Credit Score Service expectation")

        var result: Result<CreditScore>?
        service.fetchCredit { r in
            result = r
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)

        guard let r = result, case let .failure(error) = r else {
            XCTFail("Unexpected result")
            return
        }

        guard let returnedError = error as? ClearScoreCreditService.Error,
            case .networkError = returnedError else {
            XCTFail("Unexpected error")
            return
        }
    }

    func test_clearScoreCreditService_200_invalidResponse() {
        let mockSession = MockURLSession(responseData: invalidResponseData)
        let service: CreditService = ClearScoreCreditService(session: mockSession)
        let expectation = self.expectation(description: "Credit Score Service expectation")

        var result: Result<CreditScore>?
        service.fetchCredit { r in
            result = r
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)

        guard let r = result, case let .failure(error) = r else {
            XCTFail("Unexpected result")
            return
        }

        guard let returnedError = error as? ClearScoreCreditService.Error,
            case .parsing = returnedError else {
            XCTFail("Unexpected error")
            return
        }
    }

    func test_clearScoreCreditService_403() {
        let mockSession = MockURLSession(responseData: invalidResponseData, responseError: nil, statusCode: 403)
        let service: CreditService = ClearScoreCreditService(session: mockSession)
        let expectation = self.expectation(description: "Credit Score Service expectation")

        var result: Result<CreditScore>?
        service.fetchCredit { r in
            result = r
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)

        guard let r = result, case let .failure(error) = r else {
            XCTFail("Unexpected result")
            return
        }

        guard let returnedError = error as? ClearScoreCreditService.Error,
            case .badResponse = returnedError else {
            XCTFail("Unexpected error")
            return
        }
    }

    func test_clearScoreCreditService_200_validResponse() {
        let mockSession = MockURLSession(responseFile: "credit")
        let service: CreditService = ClearScoreCreditService(session: mockSession)
        let expectation = self.expectation(description: "Credit Score Service expectation")

        var result: Result<CreditScore>?
        service.fetchCredit { r in
            result = r
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)

        guard let r = result, case let .success(creditScore) = r else {
            XCTFail("Unexpected result")
            return
        }

        XCTAssertEqual(creditScore.creditReportInfo.score, 514)
        XCTAssertEqual(creditScore.creditReportInfo.maxScoreValue, 700)
    }
}

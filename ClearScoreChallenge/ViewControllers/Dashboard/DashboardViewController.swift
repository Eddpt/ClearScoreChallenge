//  Copyright © 2018 Edgar Antunes. All rights reserved.

import UIKit

final class DashboardViewController: UIViewController {
    private let service: CreditService = ClearScoreCreditService()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCreditScore()
    }

    private func fetchCreditScore() {
        service.fetchCredit { result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(creditScore):
                print(creditScore)
            }
        }
    }
}


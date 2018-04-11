//  Copyright © 2018 Edgar Antunes. All rights reserved.

import UIKit

final class DashboardViewController: UIViewController {
    private let service: CreditService = ClearScoreCreditService()
    private let donutView = DonutView.fromNib()
    private let creditScoreView = CreditScoreView.fromNib()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        fetchCreditScore()
    }

    private func setupUI() {
        donutView.translatesAutoresizingMaskIntoConstraints = false
        creditScoreView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(donutView)

        NSLayoutConstraint.activate([
            donutView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 50),
            view.rightAnchor.constraint(greaterThanOrEqualTo: donutView.rightAnchor, constant: 50),
            donutView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            donutView.heightAnchor.constraint(equalTo: donutView.widthAnchor),
            donutView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        donutView.setup(with: creditScoreView)
    }

    private func fetchCreditScore() {
        service.fetchCredit { [weak self] result in
            var creditScore: CreditScore?
            switch result {
            case let .failure(error):
                print(error)
            case let .success(result):
                creditScore = result
            }

            self?.updateUI(with: creditScore)
        }
    }

    private func updateUI(with creditScore: CreditScore?) {
        var percentage: CGFloat?
        if let creditScoreInfo = creditScore?.creditReportInfo {
            percentage = CGFloat(creditScoreInfo.score) / CGFloat(creditScoreInfo.maxScoreValue)
        }

        DispatchQueue.main.async {
            self.creditScoreView.update(with: creditScore)
            self.donutView.animateCircle(with: percentage)
        }
    }
}

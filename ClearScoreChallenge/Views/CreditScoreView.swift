//  Copyright © 2018 Edgar Antunes. All rights reserved.

import UIKit

final class CreditScoreView: UIView {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var maximumScoreLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()

        clearUI()

        setupUI()
    }

    func update(with creditScore: CreditScore?) {
        guard let creditScore = creditScore else {
            scoreLabel.text = "-"
            maximumScoreLabel.text = "out of -"

            animateUI()
            return
        }

        scoreLabel.text = "\(creditScore.creditReportInfo.score)"
        maximumScoreLabel.text = "out of \(creditScore.creditReportInfo.maxScoreValue)"

        animateUI()
    }

    private func clearUI() {
        descriptionLabel.text = nil
        scoreLabel.text = nil
        maximumScoreLabel.text = nil
    }

    private func setupUI() {
        descriptionLabel.textColor = .white
        scoreLabel.textColor = .white
        maximumScoreLabel.textColor = .white

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        scoreLabel.font = UIFont.systemFont(ofSize: 60, weight: .light)
        maximumScoreLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)

        descriptionLabel.text = "Your credit score is"
    }

    private func animateUI() {
        UIView.animate(withDuration: 0.7) {
            self.activityIndicator.alpha = 0.0
            self.scoreLabel.alpha = 1.0
            self.maximumScoreLabel.alpha = 1.0
        }
    }
}

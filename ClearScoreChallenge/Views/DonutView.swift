//  Copyright © 2018 Edgar Antunes. All rights reserved.

import UIKit

final class DonutView: UIView {
    private static let progressLineWidth: CGFloat = 5.0

    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerViewLeadingConstraint: NSLayoutConstraint!
    private let gradientMask = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()

    private var radius: CGFloat {
        return layer.frame.width / 2
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        visualEffectView.layer.borderWidth = 1.0
        visualEffectView.layer.borderColor = UIColor.white.cgColor

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.50
        layer.shadowOffset = .zero
        layer.shadowRadius = 5

        gradientMask.fillColor = UIColor.clear.cgColor
        gradientMask.lineCap = kCALineCapRound
        gradientMask.strokeColor = UIColor.black.cgColor
        gradientMask.lineWidth = DonutView.progressLineWidth
        gradientMask.strokeEnd = 0

        gradientLayer.colors = [
            UIColor.babyOrange.cgColor,
            UIColor.dimYellow.cgColor,
            UIColor.positiveGreen.cgColor,
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.mask = gradientMask

        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        visualEffectView.layer.cornerRadius = radius
        layer.cornerRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: radius).cgPath

        adjustGradientLayer()
        adjustContainerSize()
    }

    func setup(with childView: UIView) {
        containerView.addSubview(childView)

        NSLayoutConstraint.activate([
            childView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            childView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            childView.topAnchor.constraint(equalTo: containerView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }

    func animateCircle(with percentage: CGFloat?) {
        guard let percentage = percentage else { return }

        adjustGradientPath(startAngle: -CGFloat(.pi / 2.0), delta: percentage * 2.0 * .pi)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.7
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        gradientMask.strokeEnd = 1.0
        gradientMask.add(animation, forKey: "animateCircle")
    }

    private func adjustGradientLayer() {
        gradientMask.frame = bounds
        gradientLayer.frame = bounds

        adjustGradientPath()
    }

    private func adjustGradientPath(startAngle: CGFloat = -.pi / 2, delta: CGFloat = 2 * .pi) {
        gradientMask.path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius),
                                         radius: radius - DonutView.progressLineWidth,
                                         startAngle: startAngle,
                                         endAngle: startAngle + delta,
                                         clockwise: true).cgPath
    }

    private func adjustContainerSize() {
        let padding = (layer.bounds.width - layer.bounds.width / sqrt(2)) / 2 + DonutView.progressLineWidth

        containerViewTopConstraint.constant = round(padding)
        containerViewLeadingConstraint.constant = round(padding)
    }
}

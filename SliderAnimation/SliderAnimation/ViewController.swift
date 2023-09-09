//
//  ViewController.swift
//  SliderAnimation
//
//  Created by Igor Tumanov on 09.09.2023.
//

import UIKit

final class ViewController: UIViewController {

    private enum Constants {
        static let squareSize: CGFloat = 100
        static let scaleFactor: Float = 1.5
        static let animationDuration: TimeInterval = 1.0
    }

    private let square = UIView()
    private let slider = UISlider()

    private var animator: UIViewPropertyAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        square.backgroundColor = .systemBlue
        square.layer.cornerRadius = 8

        slider.isContinuous = true
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)

        view.addSubview(square)
        square.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            square.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            square.heightAnchor.constraint(equalToConstant: Constants.squareSize),
            square.widthAnchor.constraint(equalToConstant: Constants.squareSize),
            square.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),

            slider.topAnchor.constraint(equalTo: square.bottomAnchor, constant: 50),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            slider.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        view.layoutMarginsDidChange()
    }

    @objc private func sliderTouchUp() {
        let remainDuration = Constants.animationDuration - Constants.animationDuration * Double(slider.value)
        animator = UIViewPropertyAnimator(duration: remainDuration, curve: .easeInOut) { [weak self] in
            self?.slider.setValue(1, animated: true)
            self?.transformSquare(with: 1)
        }
        animator?.startAnimation()
    }

    @objc private func valueChanged() {
        self.transformSquare(with: slider.value)
    }

    func transformSquare(with value: Float) {
        let finalCenterX = view.bounds.width - Constants.squareSize * CGFloat(Constants.scaleFactor) - view.layoutMargins.right

        let newSize = value * (Constants.scaleFactor - 1) + 1.0
        let newAngle = value * .pi / 2

        let updatedCenterX = view.layoutMargins.left + (Constants.squareSize / 2) + (finalCenterX * CGFloat(value))

        square.transform = .init(scaleX: CGFloat(newSize), y: CGFloat(newSize)).rotated(by: CGFloat(newAngle))
        square.center.x = updatedCenterX
    }
}

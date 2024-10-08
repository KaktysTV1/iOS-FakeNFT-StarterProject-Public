//
//  RatingView.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 27.08.2024.
//

import UIKit

final class RatingView: UIView {
    
    private lazy var starsStacView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(starsStacView)

        NSLayoutConstraint.activate([
            starsStacView.topAnchor.constraint(equalTo: topAnchor),
            starsStacView.bottomAnchor.constraint(equalTo: bottomAnchor),
            starsStacView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starsStacView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        starsStacView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setStars(with rating: Int) {
        removeAllArrangedSubviews()
        var index = 0
        repeat {
            let view = UIImageView()
            starsStacView.addArrangedSubview(view)
            view.image = index < rating  ? UIImage(named: "goldStar") : UIImage(named: "grayStar")
            index += 1
        } while index < 5
    }

    func removeAllArrangedSubviews() {
        starsStacView.arrangedSubviews.forEach {
            starsStacView.removeArrangedSubview($0)
        }
    }
}


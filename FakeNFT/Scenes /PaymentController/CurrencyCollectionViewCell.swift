//
//  CurrencyCollectionViewCell.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 28.08.2024.
//

import UIKit
import Kingfisher

final class CurrencyCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    private (set) var currency: CurrencyDataModel?
    
//MARK: - UI Elements
    
    private lazy var imageFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var currencyImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        return label
    }()
    
    private lazy var currencyShortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = UIColor(named: "Green")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Private Metods
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(named: "LightGray")
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor(named: "Black")?.cgColor
        contentView.addSubview(imageFieldView)
        contentView.addSubview(currencyNameLabel)
        contentView.addSubview(currencyShortNameLabel)
        imageFieldView.addSubview(currencyImage)
        
        NSLayoutConstraint.activate([
            imageFieldView.heightAnchor.constraint(equalToConstant: 36),
            imageFieldView.widthAnchor.constraint(equalToConstant: 36),
            imageFieldView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageFieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            currencyImage.centerXAnchor.constraint(equalTo: imageFieldView.centerXAnchor),
            currencyImage.centerYAnchor.constraint(equalTo: imageFieldView.centerYAnchor),
            currencyImage.heightAnchor.constraint(equalToConstant: 31.5),
            currencyImage.widthAnchor.constraint(equalToConstant: 31.5),
            
            currencyNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            currencyNameLabel.leadingAnchor.constraint(equalTo: imageFieldView.trailingAnchor, constant: 4),
            
            currencyShortNameLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor),
            currencyShortNameLabel.leadingAnchor.constraint(equalTo: currencyNameLabel.leadingAnchor)
        ])
        
        imageFieldView.translatesAutoresizingMaskIntoConstraints = false
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyShortNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
//MARK: - Metods
    
    func updateCell(currency: CurrencyDataModel) {
        self.currency = currency
        currencyNameLabel.text = currency.title
        currencyShortNameLabel.text = currency.name
        let image = URL(string: currency.image)
        currencyImage.kf.setImage(with: image, placeholder: UIImage(named: "close"))
    }
    
    func selectedCell(wasSelected: Bool) {
        contentView.layer.borderWidth = wasSelected ? 1 : 0
    }
}

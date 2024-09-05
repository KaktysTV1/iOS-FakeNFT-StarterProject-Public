//
//  SuccessPayController.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 28.08.2024.
//

import UIKit

final class SuccessPayController: UIViewController {
    
    private lazy var successImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "SuccessImage")
        return image
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.headline3
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        return textLabel
    }()
    
    private lazy var catalogButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(named: "Black")
        button.setTitle("Вернуться в каталог", for: .normal)
        button.addTarget(self, action: #selector(didTapCatalogButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "White")
        view.addSubview(successImage)
        view.addSubview(textLabel)
        view.addSubview(catalogButton)
        
        NSLayoutConstraint.activate([
            successImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successImage.widthAnchor.constraint(equalToConstant: 278),
            successImage.heightAnchor.constraint(equalToConstant: 278),
            successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textLabel.topAnchor.constraint(equalTo: successImage.bottomAnchor,constant: 20),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            
            catalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            catalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            catalogButton.heightAnchor.constraint(equalToConstant: 60),
            catalogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)

        ])
        
        successImage.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        catalogButton.translatesAutoresizingMaskIntoConstraints = false

    }
    
    @objc private func didTapCatalogButton() {
        self.dismiss(animated: true)
    }
}


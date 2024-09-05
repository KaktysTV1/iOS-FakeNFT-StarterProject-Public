//
//  CartDeleteViewController.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 27.08.2024.
//

import UIKit

protocol CartDeleteControllerProtocol: AnyObject {
    func showNetworkError(message: String)
    func startLoadIndicator()
    func stopLoadIndicator()
}

final class CartDeleteViewController: UIViewController, CartDeleteControllerProtocol {
    
    var presenter: CartDeletePresenterProtocol?
    private let servicesAssembly: ServicesAssembly
    private (set) var nftImage: UIImage
    private var idForDelete: String
    
    init(servicesAssembly: ServicesAssembly, nftImage: UIImage, idForDelete: String) {
        self.servicesAssembly = servicesAssembly
        self.nftImage = nftImage
        self.idForDelete = idForDelete
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var fieldView: UIView = {
        let field = UIView()
        return field
    }()
    
    private lazy var nftImageView: UIImageView = {
        let nftImage = UIImageView()
        nftImage.layer.masksToBounds = true
        nftImage.layer.cornerRadius = 12
        nftImage.image = self.nftImage
        return nftImage
    }()
    
    private lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.text = "Вы уверены, что хотите удалить объект из корзины?"
        questionLabel.font = .bodyRegular
        questionLabel.numberOfLines = 2
        questionLabel.textAlignment = .center
        return questionLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        deleteButton.backgroundColor = UIColor(named: "Black")
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 12
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return deleteButton
    }()
    
    private lazy var returnButton: UIButton = {
        let returnButton = UIButton()
        returnButton.setTitle("Вернуться", for: .normal)
        returnButton.backgroundColor = UIColor(named: "Black")
        returnButton.layer.masksToBounds = true
        returnButton.layer.cornerRadius = 12
        returnButton.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
        return returnButton
    }()
    
    private let loaderView = LoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        
        view.addSubview(blurView)
        view.addSubview(fieldView)
        view.addSubview(nftImageView)
        view.addSubview(questionLabel)
        view.addSubview(deleteButton)
        view.addSubview(returnButton)
        view.addSubview(loaderView)
        loaderView.constraintCenters(to: view)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            fieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldView.heightAnchor.constraint(equalToConstant: 220),
            fieldView.widthAnchor.constraint(equalToConstant: 262),
            fieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.centerXAnchor.constraint(equalTo: fieldView.centerXAnchor),
            nftImageView.topAnchor.constraint(equalTo: fieldView.topAnchor),
            
            questionLabel.centerXAnchor.constraint(equalTo: fieldView.centerXAnchor),
            questionLabel.widthAnchor.constraint(equalToConstant: 260),
            questionLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            
            returnButton.heightAnchor.constraint(equalToConstant: 44),
            returnButton.widthAnchor.constraint(equalToConstant: 127),
            returnButton.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor),
            returnButton.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: fieldView.leadingAnchor)
        ])
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        fieldView.translatesAutoresizingMaskIntoConstraints = false
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func didTapReturnButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDeleteButton() {
        presenter?.deleteNftFromCart { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.dismiss(animated: true)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func startLoadIndicator() {
        loaderView.showLoading()
    }
    
    func stopLoadIndicator() {
        loaderView.hideLoading()
    }
    
    func showNetworkError(message: String) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Произошла ошибка, повторить?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Еще раз", style: .default) { _ in
            self.presenter?.deleteNftFromCart { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.dismiss(animated: true)
                case let .failure(error):
                    print (error)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
}


//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 28.08.2024.
//

import Foundation

//MARK: - Protocol

protocol PaymentPresenterProtocol {
    var selectedCurrency: CurrencyDataModel? { get set }
    func count() -> Int
    func getCurrencies()
    func getModel(indexPath: IndexPath) -> CurrencyDataModel
    func payOrder()
}

final class PaymentPresenter: PaymentPresenterProtocol {
    
    private weak var paymentController: PaymentViewControllerProtocol?
    private var paymentService: PaymentServiceProtocol?
    private var orderService: OrderServiceProtocol?
    private var currencies: [CurrencyDataModel] = []
    var selectedCurrency: CurrencyDataModel? {
        didSet {
            if selectedCurrency != nil {
                paymentController?.didSelectCurrency(isEnable: true)
            }
        }
    }
    
    init(paymentController: PaymentViewControllerProtocol, paymentService: PaymentServiceProtocol, orderService: OrderServiceProtocol) {
        self.paymentController = paymentController
        self.paymentService = paymentService
        self.orderService = orderService
    }
    
//MARK: - Metods
    
    func getCurrencies() {
        paymentController?.startLoadIndicator()
        paymentService?.getCurrencies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.currencies = data
                self.paymentController?.updateCurrencyList()
                self.paymentController?.stopLoadIndicator()
            case let .failure(error):
                print(error)
                self.paymentController?.stopLoadIndicator()
            }
        }
    }
    
    func getModel(indexPath: IndexPath) -> CurrencyDataModel {
        let model = currencies[indexPath.row]
        return model
    }
    
    func count() -> Int {
        let count: Int = currencies.count
        return count
    }
    
    func payOrder() {
        paymentController?.startLoadIndicator()
        guard let selectedCurrency = selectedCurrency else { return }
        paymentService?.payOrder(currencyId: selectedCurrency.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.emptyCart()
                self.paymentController?.didPayment(paymentResult: data.success)
                self.paymentController?.stopLoadIndicator()
            case .failure(_):
                self.paymentController?.didPayment(paymentResult: false)
                self.paymentController?.stopLoadIndicator()
            }
        }
    }
    
    func emptyCart() {
        orderService?.removeAllNftFromStorage() { result in
            switch result {
            case let .success(data):
                break
            case .failure(_):
                break
            }
        }
    }
}

//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Андрей Чупрыненко on 28.08.2024.
//

import Foundation

protocol PaymentPresenterProtocol {
    var selectedCurrency: CurrencyDataModel? { get set }
    func count() -> Int
    func getModel(indexPath: IndexPath) -> CurrencyDataModel
    func payOrder()
    func getCurrencies()
}

final class PaymentPresenter: PaymentPresenterProtocol {
    
    private weak var paymentController: PaymentViewControllerProtocol?
    private var currencies: [CurrencyDataModel] = []
    var selectedCurrency: CurrencyDataModel? {
        didSet {
            if selectedCurrency != nil {
            paymentController?.didSelectCurrency(isEnable: true)
            }
        }
    }
    
    var mock1 = CurrencyDataModel(title: "Bitcoin", name: "BTC", image: "Bitcoin", id: "1")
    var mock2 = CurrencyDataModel(title: "Tether", name: "USDT", image: "Tether", id: "2")
    
    init(paymentController: PaymentViewControllerProtocol) {
        self.paymentController = paymentController
        self.currencies = [mock1, mock2]
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
        
        var result = Int.random(in: 0..<2)
        
        switch result {
            case 1:
                paymentController?.didPayment(paymentResult: true)
                paymentController?.stopLoadIndicator()
            case 0:
                paymentController?.didPayment(paymentResult: false)
                paymentController?.stopLoadIndicator()
        default:
            print("something werid")
        }
        
        /*paymentService?.payOrder(currencyId: selectedCurrency.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            }
        }*/
    }
    
    func getCurrencies() {
        paymentController?.startLoadIndicator()
            
    }
}

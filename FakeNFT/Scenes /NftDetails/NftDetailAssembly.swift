import UIKit

public final class NftDetailAssembly {
    
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build(with input: NftDetailInput) -> UIViewController {
        guard let nftService = servicesAssembler.nftService as? NftService else {
            print("Ошибка: NftService не найден.")
            return UIViewController()
        }

        
        let presenter = NftDetailPresenterImpl(
            input: input,
            service: nftService
        )
        
        let viewController = NftDetailViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}

//Inital commite

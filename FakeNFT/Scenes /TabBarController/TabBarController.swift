import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: "Каталог",
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: "Корзина",
        image: UIImage(named: "Cart"),
        tag: 2
    )
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let servicesAssembly else { return }

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartController = CartViewController(servicesAssembly: servicesAssembly)
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        
        cartController.tabBarItem = cartTabBarItem

        viewControllers = [catalogController, cartNavigationController]

        view.backgroundColor = .systemBackground
    }
}

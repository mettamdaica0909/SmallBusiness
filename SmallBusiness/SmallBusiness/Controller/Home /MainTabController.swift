import Foundation
import UIKit

final class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func visualize() {
        edgesForExtendedLayout = []
        
        // tabBar
        delegate = self
        tabBar.isTranslucent = false
        
        let storyboard1 = UIStoryboard(name: "Order", bundle: nil)
        let orderListVC = storyboard1.instantiateViewController(withIdentifier: "OrderListVC")
        
        let storyboard2 = UIStoryboard(name: "Shipper", bundle: nil)
        let shipperListVC = storyboard2.instantiateViewController(withIdentifier: "ShipperListVC")
        
        let productListVC = UIStoryboard.product().vcID(identifier: "ProductListVC")
        
        let nvcOrderListVC = UINavigationController(rootViewController: orderListVC)
        let nvcShipperListVC = UINavigationController(rootViewController: shipperListVC)
        let nvcProductListVC = UINavigationController(rootViewController: productListVC)
        
        let tabControllers: [UIViewController] = [nvcOrderListVC, nvcShipperListVC, nvcProductListVC]
        
        let title0 = "Order"
        let title1 = "Shipper"
        let title2 = "Product"
        
        tabControllers[0].tabBarItem = UITabBarItem(title: title0,
                                                    image: #imageLiteral(resourceName: "Money"),
                                                    selectedImage: #imageLiteral(resourceName: "Money"))
        
        tabControllers[1].tabBarItem = UITabBarItem(title: title1,
                                                    image: #imageLiteral(resourceName: "Money"),
                                                    selectedImage: #imageLiteral(resourceName: "Money"))
        
        tabControllers[2].tabBarItem = UITabBarItem(title: title2,
                                                    image: #imageLiteral(resourceName: "shopadmin_additem"),
                                                    selectedImage: #imageLiteral(resourceName: "shopadmin_additem"))
        
        for item in tabControllers {
            let offset = CGFloat(0)
            let imageInset = UIEdgeInsetsMake(offset, 0, -offset, 0)
            item.tabBarItem.imageInsets = imageInset
            item.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0)
        }
        viewControllers = tabControllers        
        tabBar.tintColor = UIColor(hex: 0xED1C26)
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

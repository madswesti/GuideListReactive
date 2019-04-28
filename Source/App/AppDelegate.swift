import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let rootViewController = GuidesTableViewController(viewModel: GuideListViewModel(service: Service()))
		
		self.window = UIWindow()
		self.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
		self.window?.makeKeyAndVisible()
		
		return true
	}
}


private extension Service {
	// Would be handle by some DI framework or similar, in a real application.
	convenience init() {
		let baseURL = URL(string: "https://private-c60ade-guidebook1.apiary-mock.com")!
		let networkClient = NetworkClient(baseURL: baseURL)
		self.init(networkClient: networkClient)
	}
}

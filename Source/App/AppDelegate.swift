import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let rootViewController = UIViewController()
		rootViewController.view.backgroundColor = .white
		
		self.window = UIWindow()
		self.window?.rootViewController = rootViewController
		self.window?.makeKeyAndVisible()
		
		return true
	}
}

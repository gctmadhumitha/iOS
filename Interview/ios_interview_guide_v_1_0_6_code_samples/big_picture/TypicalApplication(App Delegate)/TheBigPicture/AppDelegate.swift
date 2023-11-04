import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let rootViewController = storyboard.instantiateInitialViewController()
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
    self.window = window
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    print("applicationWillResignActive")
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    print("applicationDidEnterBackground")
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    print("applicationWillEnterForeground")
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    print("applicationDidBecomeActive")
  }

  func applicationWillTerminate(_ application: UIApplication) {
    print("applicationWillTerminate")
  }
}

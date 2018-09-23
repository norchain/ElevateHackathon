import UIKit

protocol PeerGetMessageDelegate: class {
    var loaded: Bool { get }
    func didGetMessageFromPeer(message: String)
    func didGetUpdatePeer(connections: [String])
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let colorService = ColorService()
    
    weak var delegate: PeerGetMessageDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        colorService.delegate = self
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate : ColorServiceDelegate {
    
    func connectedDevicesChanged(manager: ColorService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            if connectedDevices.count > 0 {
                if let delegate = self.delegate {
                    if delegate.loaded {
                        delegate.didGetUpdatePeer(connections: connectedDevices)
                        return
                    }
                    
                } else {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ColorSwitchViewController") as! ColorSwitchViewController
                    
                    viewController.connections = connectedDevices
                    
                    self.delegate = viewController
                    
                    self.window?.rootViewController?.present(viewController, animated: true, completion: {
                        self.delegate?.didGetUpdatePeer(connections: connectedDevices)
                    })
                }
            }
        }
    }
    
    func colorChanged(manager: ColorService, colorString: String) {
        OperationQueue.main.addOperation {
            self.delegate?.didGetMessageFromPeer(message: colorString)
        }
    }
    
}

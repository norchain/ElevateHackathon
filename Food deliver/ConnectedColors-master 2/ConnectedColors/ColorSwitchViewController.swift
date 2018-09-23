import UIKit
import UserNotifications

class ColorSwitchViewController: UIViewController {

    @IBOutlet weak var connectionsLabel: UILabel!

    let colorService = ColorService()

    override func viewDidLoad() {
        super.viewDidLoad()
        colorService.delegate = self
    }

    @IBAction func redTapped() {
        colorService.send(colorName: "red")
    }

    @IBAction func yellowTapped() {
        colorService.send(colorName: "yellow")
    }
    
}

extension ColorSwitchViewController : ColorServiceDelegate {

    func connectedDevicesChanged(manager: ColorService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }

    func colorChanged(manager: ColorService, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                self.sendNotification()
            case "yellow":
                print("docation")
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
    
    func sendNotification() {
        let alert = UIAlertController(title: "Customer confirmed", message: "Order complete", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

}

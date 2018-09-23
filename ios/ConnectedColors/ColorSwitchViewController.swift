import UIKit
import LocalAuthentication

class ColorSwitchViewController: UIViewController {

    @IBOutlet weak var connectionsLabel: UILabel!
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    var hasConnection = false {
        didSet {
            payButton.isEnabled = hasConnection
        }
    }
    
    var restuarant: Restaurant?

    @IBAction func triggerTouchID(_ sender: UIButton) {
        authenticateUserTouchID()
    }
    let colorService = ColorService()

    override func viewDidLoad() {
        super.viewDidLoad()
        colorService.delegate = self
    }

    @IBAction func redTapped() {
        self.change(color: .red)
        colorService.send(colorName: "red")
    }

    @IBAction func yellowTapped() {
        self.change(color: .yellow)
        colorService.send(colorName: "yellow")
    }

    func change(color : UIColor) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = color
            }
        }
    }
    
    func authenticateUserTouchID() {
        let context : LAContext = LAContext()
        let myLocalizedReasonString = "Authentication is needed to make the payment."
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showRating", sender: self)
                    }
                } else {
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? RateViewController {
            dvc.restaurant = restuarant
        }
    }
}

extension ColorSwitchViewController : ColorServiceDelegate {

    func connectedDevicesChanged(manager: ColorService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
            
            self.hasConnection = connectedDevices.count > 0
        }
    }

    func colorChanged(manager: ColorService, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                self.change(color: .red)
            case "yellow":
                self.change(color: .yellow)
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }

}

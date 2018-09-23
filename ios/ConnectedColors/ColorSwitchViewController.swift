import UIKit
import LocalAuthentication
import Cosmos
import JGProgressHUD

class ColorSwitchViewController: UIViewController, PeerGetMessageDelegate {

    @IBOutlet weak var connectionsLabel: UILabel!
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            if let app = UIApplication.shared.delegate as? AppDelegate {
                app.delegate = nil
            }
        }
    }
    
    
    var connections: [String]?
    
    var rate: String = ""
    
    var viewLoad = false
    
    var worker = RestaurantWorker(service: RestaurantService())
    
    @IBOutlet weak var rateView: CosmosView!
    var restuarant: Restaurant?

    @IBAction func triggerTouchID(_ sender: UIButton) {
        authenticateUserTouchID()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoad = true
        
        if let accountsData = UserDefaults.standard.data(forKey: "Purchase"),
            let rests = try? JSONDecoder().decode([Restaurant].self, from: accountsData) {
            restuarant = rests.first
        }
        
        payButton.isEnabled = false
        
        rateView.settings.updateOnTouch = true
        
        rateView.didTouchCosmos =  { rate in
            DispatchQueue.main.async {
                self.payButton.isEnabled = true
                self.rate = "\(rate)"
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewLoad = false
    }

    @IBAction func redTapped() {
        self.change(color: .red)
    }

    @IBAction func yellowTapped() {
        self.change(color: .yellow)
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
                    let hud = JGProgressHUD(style: .dark)
                    
                    DispatchQueue.main.async {
                        hud.textLabel.text = "Loading"
                        hud.show(in: self.view)
                    }
                    
                    
                    
                    let client = UserDefaults.standard.string(forKey: "UserID") ?? ""
                    let td = self.restuarant?.TD_account ?? ""
                    let r = "\(self.rate)"
                    let comment = ""
                    self.worker.rate(client_id: client, td_account: td, stars: r, comment: comment, complete: { (review) in
                        DispatchQueue.main.async {
                            hud.dismiss()
                            UserDefaults.standard.removeObject(forKey: "Purchase")
                            switch review {
                            case .Success(let re):
                                self.dismiss(animated: true, completion: {
                
                                })
                            case .Failure(let error):
                                let alert = UIAlertController(title: "Rate failed", message: "", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                            self.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true)
                            }
                        }
                        
                    })
                } else {
                    let alert = UIAlertController(title: "Rate failed", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK:
    
    var loaded: Bool {
        return viewLoad
    }
    
    func didGetMessageFromPeer(message: String) {
        
    }
    
    func didGetUpdatePeer(connections: [String]) {
        if viewLoad {
            connectionsLabel.text = connections.reduce("") { $0 + " " + $1 }
        }
    }
}

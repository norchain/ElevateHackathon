//
//  ProfileViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import JGProgressHUD

class ProfileViewController: UIViewController {
    var worker: UserWorker = UserWorker(http: HTTPService())
    
    var user: User?
    var error = ""

    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var surNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workActivityLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var relationshipLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = "8653b028-8365-436c-938f-85c99ff31e6e_c418b5e6-ef7a-4774-88bc-762f2e9adc53"
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        worker.getUser(id: id) { [weak self] result in
            switch result {
            case .Success(let user):
                self?.user = user
                self?.givenNameLabel.text = user.giveName
                self?.surNameLabel.text = user.surname
                self?.ageLabel.text = "\(user.age ?? 0)"
                self?.genderLabel.text = user.gender?.rawValue
                if let addresses = user.addresses, let address = addresses["principalResidence"] {
                    self?.addressLabel.text = address.desciption
                }
                self?.workActivityLabel.text = user.workActivity?.rawValue
                self?.occupationLabel.text = user.occupationIndustry
                self?.incomeLabel.text = "\(user.totalIncome ?? 0)"
                self?.relationshipLabel.text = user.relationshipStatus?.rawValue
            case .Failure(let error):
                self?.error = error.localizedDescription
            }
            hud.dismiss()
        }
    }
    
    
}

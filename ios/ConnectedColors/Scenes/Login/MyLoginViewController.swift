//
//  MyLoginViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import ILLoginKit
import FBSDKLoginKit
import JGProgressHUD
import RAMAnimatedTabBarController

class MyLoginViewController: LoginViewController {
    var worker: UserWorker = UserWorker(http: HTTPService())

    override func viewDidLoad() {
        configureAppearance()
        
        delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func configureAppearance() {
        configuration = DefaultConfiguration(backgroundImage: UIImage(named: "background")!,
                                             backgroundImageGradient: false,
                                             tintColor: UIColor.black,
                                             errorTintColor: UIColor.white,
                                             signupButtonText: "",
                                             loginButtonText: "Login",
                                             facebookButtonText: "",
                                             forgotPasswordButtonText: "forget password?",
                                             recoverPasswordButtonText: "",
                                             emailPlaceholder: "username",
                                             passwordPlaceholder: "enter your pw",
                                             repeatPasswordPlaceholder: "",
                                             namePlaceholder: "",
                                             shouldShowSignupButton: false,
                                             shouldShowLoginButton: true,
                                             shouldShowFacebookButton: false,
                                             shouldShowForgotPassword: false)
    }
    


}

extension MyLoginViewController: LoginViewControllerDelegate {
    func didSelectLogin(_ viewController: UIViewController, email: String, password: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            let userId = Authentication().login(username: email, password: password)
            
            
            if let userId = userId {
                self.worker.getUser(id: userId, complete: { (result) in
                    switch result {
                    case .Success(let user):
                        if let dic = user.maskedRelatedBankAccounts, let accounts = dic["individual"] {
                            let kUser = "BankAccounts"
                            
                            if let encoded = try? JSONEncoder().encode(accounts) {
                                UserDefaults.standard.set(encoded, forKey: kUser)
                            }
                        }
                    case .Failure(let error):
                        let alert = UIAlertController(title: "Something goes wrong: \(error.localizedDescription)", message: "please try again later", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true)
                    }
                })
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController") as! UITabBarController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            } else {
                hud.dismiss(animated: true)
                let alert = UIAlertController(title: "Wrong credential", message: "please check your email and password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        })
        
        
    }
    
    func didSelectForgotPassword(_ viewController: UIViewController) {
        // nothing
    }
    
    func loginDidSelectBack(_ viewController: UIViewController) {
        
    }
    
}

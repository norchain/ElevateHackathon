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

class MyLoginViewController: LoginViewController {

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
            let logined = Authentication().login(username: email, password: password)
            hud.dismiss(animated: true)
            
            if logined {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MyTabBarViewController") as! UITabBarController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
        })
        
        
    }
    
    func didSelectForgotPassword(_ viewController: UIViewController) {
        // nothing
    }
    
    func loginDidSelectBack(_ viewController: UIViewController) {
        
    }
    
}

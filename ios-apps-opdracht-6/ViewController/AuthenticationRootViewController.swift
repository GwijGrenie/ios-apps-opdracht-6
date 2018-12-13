//
//  ViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit

protocol AuthenticationUIDelegate {
    func onLoginAuthenticated()
}

class AuthentictationRootViewController: UIViewController {
    
    private var embeddedViewController: UIViewController!
    
    private lazy var loginViewController: LoginViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        embeddedViewController.addChild(viewController)
        return viewController
    }()
    
    private lazy var registerViewController: RegistrationViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "registerViewController") as! RegistrationViewController
        embeddedViewController.addChild(viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedSegue" {
            self.embeddedViewController = segue.destination
            add(asChildViewController: loginViewController)
        }
    }
    
    @IBAction func onValueChangedNavigation(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Login")
            remove(asChildViewController: registerViewController)
            add(asChildViewController: loginViewController)
            break
        case 1:
            print("Register")
            remove(asChildViewController: loginViewController)
            add(asChildViewController: registerViewController)
            break
        default:
            remove(asChildViewController: registerViewController)
            add(asChildViewController: loginViewController)
            break
        }
    }
}

extension AuthentictationRootViewController {
    private func add(asChildViewController viewController: UIViewController) {
        embeddedViewController.addChild(viewController)
        embeddedViewController.view.addSubview(viewController.view)
        viewController.view.frame = embeddedViewController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: embeddedViewController)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

extension AuthentictationRootViewController: AuthenticationUIDelegate {
    func onLoginAuthenticated() {
        self.performSegue(withIdentifier: "SegueLoggedIn", sender: self)
    }
}

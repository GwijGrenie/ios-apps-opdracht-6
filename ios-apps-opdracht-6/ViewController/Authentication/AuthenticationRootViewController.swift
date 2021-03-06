//
//  ViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit

class AuthentictationRootViewController: UIViewController {
    
    // MARK: Instance variables
    
    private var embeddedViewController: UIViewController!
    private var member: Member!
    
    private lazy var loginViewController: LoginViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        embeddedViewController.addChild(viewController)
        return viewController
    }()
    
    private lazy var registrationViewController: RegistrationViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "registerViewController") as! RegistrationViewController
        embeddedViewController.addChild(viewController)
        return viewController
    }()
    
    // MARK: IBActions
    
    @IBAction func onValueChangedNavigation(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            remove(AsChildViewController: registrationViewController)
            add(AsChildViewController: loginViewController)
            break
        case 1:
            remove(AsChildViewController: loginViewController)
            add(AsChildViewController: registrationViewController)
            break
        default:
            // Should not happen
            break
        }
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PresentAuthenticationContent":
            self.embeddedViewController = segue.destination
            add(AsChildViewController: loginViewController)
            break
        case "PresentHome":
            let articleListTableViewController: ArticleListTableViewController = segue.destination as! ArticleListTableViewController
            articleListTableViewController.currentMember = member
            break
        default:
            break
        }
    }
    
    // MARK: Local helpers
    
    private func add(AsChildViewController viewController: UIViewController) {
        embeddedViewController.addChild(viewController)
        embeddedViewController.view.addSubview(viewController.view)
        viewController.view.frame = embeddedViewController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: embeddedViewController)
    }
    
    private func remove(AsChildViewController viewController: UIViewController) {
        
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

extension AuthentictationRootViewController: AuthenticationUIDelegate {
    
    // MARK: AuthenticationUIDelegate implementation
    
    func onLoginAuthenticated(member: Member) {
        self.member = member
        self.performSegue(withIdentifier: "PresentHome", sender: self)
    }
}

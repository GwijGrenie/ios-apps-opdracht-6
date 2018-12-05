//
//  ViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    private var embeddedViewController: UIViewController!
    
    private lazy var loginViewController: LoginViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        
        embeddedViewController.addChild(viewController)
        
        return viewController
    }()
    
    private lazy var registerViewController: RegisterViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "registerViewController") as! RegisterViewController
        
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
            remove(asChildViewController: registerViewController)
            add(asChildViewController: loginViewController)
            break
        case 1:
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

extension ViewController {
    private func add(asChildViewController viewController: UIViewController) {
        embeddedViewController.addChild(viewController)
        containerView.addSubview(viewController.view)
        embeddedViewController.view.frame = view.bounds
        embeddedViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        embeddedViewController.didMove(toParent: embeddedViewController)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        embeddedViewController.willMove(toParent: nil)
        embeddedViewController.view.removeFromSuperview()
        embeddedViewController.removeFromParent()
    }
}

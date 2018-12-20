//
//  ArticleDetailViewController.swift
//  ios-apps-opdracht-6
//
//  Created by student on 20/12/2018.
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelMinimumBid: UILabel!
    @IBOutlet weak var labelHighestBid: UILabel!
    
    @IBOutlet weak var stepperCurrentBid: UIStepper!
    @IBOutlet weak var labelCurrentBid: UILabel!
    
    // MARK: IBActions
    
    @IBAction func onStepperCurrentBidValueChanged(_ sender: Any) {
        
    }
    
    @IBAction func onButtonPlaceBidTouchedUpInside(_ sender: Any) {
        
    }
    
    // MARK: Dependency injection properties
    
    var member: Member?
    var article: Article?
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: Local helpers
    
    private func configureText() {
        if let member = member {
            labelTitle.text = "Welcome " + member.name
        }
        
        if let article = article {
            labelDescription.text = article.description
            labelMinimumBid.text = String(article.minimumBidValue)
            stepperCurrentBid.minimumValue = article.minimumBidValue
            
            if article.bids.isEmpty {
                labelHighestBid.text = "No bids placed."
                labelCurrentBid.text = String(article.minimumBidValue)
                stepperCurrentBid.value = article.minimumBidValue
            } else {
                let highestBid: Double = article.bids.map({ bid in return bid.value }).max()!
                labelHighestBid.text = String(highestBid)
                labelCurrentBid.text = String(highestBid)
                stepperCurrentBid.value = highestBid
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

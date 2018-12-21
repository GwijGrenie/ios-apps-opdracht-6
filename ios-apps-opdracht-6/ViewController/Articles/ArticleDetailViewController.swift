//
//  ArticleDetailViewController.swift
//  ios-apps-opdracht-6
//
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
        labelCurrentBid.text = String(stepperCurrentBid.value)
    }
    
    @IBAction func onButtonPlaceBidTouchedUpInside(_ sender: Any) {
        let currentBid: Bid = Bid(id: String(), value: stepperCurrentBid.value, date: Date(), memberId: member!.uid)
        bidFirestoreDAO.createAsync(ForArticle: article!, currentBid, onFinished: { error in
            if error != nil {
                print(error!)
            }
        })
    }
    
    // MARK: Dependency injection properties
    
    var member: Member?
    var article: Article?
    
    // MARK: Instance variables
    
    private lazy var bidFirestoreDAO: BidFirestoreDAO = BidFirestoreDAO()
    
    private lazy var bidSnapshotCallback: BidFirestoreDAO.SnapshotListenerCallback = { article, querySnapshot, localizedError in
        guard article != nil, let querySnapshot = querySnapshot else {
            print(localizedError!)
            return
        }
        
        var bids: [Bid] = [Bid]()
        
        querySnapshot.documents.forEach({ document in
            bids.append(Bid(document))
        })
        
        self.article!.bids = bids
        self.configureText()
        self.configureStepper()
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard article != nil else {
            fatalError("article property was not set")
        }
        
        configureText()
        configureStepper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bidFirestoreDAO.registerSnapshotListener(ForArticle: article!, onSnapshot: bidSnapshotCallback)
    }
    
    // MARK: Local helpers
    
    private func configureText() {
        if let member = member {
            labelTitle.text = "Welcome " + member.name
        }
        
        if let article = article {
            labelDescription.text = article.description
            labelMinimumBid.text = "Starting price: " + String(article.minimumBidValue)
            
            if article.bids.isEmpty {
                labelHighestBid.text = "No bids placed."
                labelCurrentBid.text = String(article.minimumBidValue)
                
            } else {
                let highestBid: Double = article.bids.map({ bid in return bid.value }).max()!
                labelHighestBid.text = "Highest bid: " + String(highestBid)
                labelCurrentBid.text = String(highestBid + 20)
                
            }
        }
    }
    
    private func configureStepper() {
        if let article = article {
            if article.bids.isEmpty {
                stepperCurrentBid.value = article.minimumBidValue
                stepperCurrentBid.minimumValue = article.minimumBidValue
            } else {
                let highestBid: Double = article.bids.map({ bid in return bid.value }).max()!
                stepperCurrentBid.value = highestBid + 20
                stepperCurrentBid.minimumValue = highestBid + 20
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

//
//  ArticleListTableViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit
import Firebase

class ArticleListTableViewController: UITableViewController {
    
    // MARK: Dependency injection properties
    
    var currentMember: Member?
    
    // MARK: Read-only properties
    
    private let articleFirestoreDAO: ArticleFirestoreDAO = ArticleFirestoreDAO()
    private let bidFirestoreDAO: BidFirestoreDAO = BidFirestoreDAO()
    
    private lazy var articleSnapshotCallback: ArticleFirestoreDAO.SnapshotListenerCallback = { querySnapshot, localizedError in
        guard let querySnapshot = querySnapshot else {
            print(localizedError!)
            return
        }
        
        querySnapshot.documentChanges.forEach({ change in
            let article: Article = Article(change.document)
            switch(change.type) {
            case .added:
                self.addArticle(article)
                break
            case .removed:
                self.removeArticle(article)
                break
            case .modified:
                self.updateArticle(article)
                break
            }
        })
    }
    
    private lazy var bidSnapshotCallback: BidFirestoreDAO.SnapshotListenerCallback = { article, querySnapshot, localizedError in
        guard let article = article, let querySnapshot = querySnapshot else {
            print(localizedError!)
            return
        }
        
        var bids: [Bid] = [Bid]()
        
        querySnapshot.documents.forEach({ document in
            bids.append(Bid(document))
        })
        
        var indexOfArticle: Int = self.articles.firstIndex(where: { iteratedArticle in
            return iteratedArticle.id == article.id
        })!
        
        self.articles[indexOfArticle].bids = bids
        self.tableView.reloadData()
    }
    
    // MARK: Instance variables
    
    private var articles: [Article] = [Article]()
    
    // Deintializors
    
    deinit {
        articleFirestoreDAO.unregisterSnapshotListeners()
        bidFirestoreDAO.unregisterSnapshotListeners()
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard currentMember != nil else {
            fatalError("currentMember property was not set")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        articles = [Article]()
        articleFirestoreDAO.registerSnapshotListener(onSnapshot: articleSnapshotCallback)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        articleFirestoreDAO.unregisterSnapshotListeners()
        bidFirestoreDAO.unregisterSnapshotListeners()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath)

        let article: Article = articles[indexPath.row]
        
        cell.textLabel!.text = article.description
        
        if article.bids.isEmpty {
            cell.detailTextLabel!.text = "Startbedrag: " + String(article.minimumBidValue)
        } else {
            let highestBidValue: Double = article.bids.map({ $0.value }).max()!
            
            cell.detailTextLabel!.text = "Hoogste bod: " + String(highestBidValue)
            cell.detailTextLabel!.textColor = UIColor.blue
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let articleDetailViewController: ArticleDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticleDetails") as! ArticleDetailViewController
        articleDetailViewController.article = articles[indexPath.row]
        articleDetailViewController.member = currentMember!
        self.navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
    
    // MARK: Local helpers
    
    private func addArticle(_ articleToAdd: Article) {
        bidFirestoreDAO.getAllAsync(ForArticle: articleToAdd, onFinished: { article, bids, localizedError in
            guard var article = article, let bids = bids else {
                print(localizedError!)
                return
            }
    
            article.bids = bids
            
            self.articles.append(article)
            self.tableView.reloadData()
            
            self.bidFirestoreDAO.registerSnapshotListener(ForArticle: articleToAdd, onSnapshot: self.bidSnapshotCallback)
        })
    }
    
    private func removeArticle(_ articleToRemove: Article) {
        articles.removeAll(where: { article in
            return article.id == articleToRemove.id
        })
        bidFirestoreDAO.unregisterSnapshotListeners(ForArticle: articleToRemove)
        tableView.reloadData()
    }
    
    private func updateArticle(_ articleToUpdate: Article) {
        self.bidFirestoreDAO.unregisterSnapshotListeners(ForArticle: articleToUpdate)
        
        bidFirestoreDAO.getAllAsync(ForArticle: articleToUpdate, onFinished: { article, bids, localizedError in
            guard var article = article, let bids = bids else {
                print(localizedError!)
                return
            }
            
            article.bids = bids
            
            let row: Int = self.articles.firstIndex(where: { article in
                return article.id == articleToUpdate.id
            })!
            
            self.articles[row] = articleToUpdate
            self.tableView.reloadRow(at: IndexPath(row: row, section: 0), with: .automatic)
            self.bidFirestoreDAO.registerSnapshotListener(ForArticle: article, onSnapshot: self.bidSnapshotCallback)
        })
    }
}

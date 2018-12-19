//
//  ArticleListTableViewController.swift
//  ios-apps-opdracht-6
//
//  Created by student on 12/12/2018.
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit
import Firebase

class ArticleListTableViewController: UITableViewController {
    
    // MARK: Instance variables
    
    private var articles: [Article] = [Article]()
    
    // MARK: Read-only properties
    
    private let articleFirestoreDAO: ArticleFirestoreDAO = ArticleFirestoreDAO()
    private let bidFirestoreDAO: BidFirestoreDAO = BidFirestoreDAO()
    
    private lazy var articleSnapshotCallback: ArticleFirestoreDAO.SnapshotListenerCallback = { querySnapshot, error in
        guard let querySnapshot = querySnapshot else {
            print(error!)
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
    
    private lazy var bidSnapshotCallback: BidFirestoreDAO.SnapshotListenerCallback = { article, querySnapshot, error in
        guard let querySnapshot = querySnapshot else {
            print(error!)
            return
        }
        
        var bids: [Bid] = [Bid]()
        
        querySnapshot.documents.forEach({ document in
            bids.append(Bid(document))
        })
        
        var foundArticle: Article? = self.articles.first(where: { iteratedArticle in
            return iteratedArticle.id == article!.id
        })!
        
        foundArticle!.bids = bids
        self.tableView.reloadData()
    }
    
    // Deintializors
    
    deinit {
        articleFirestoreDAO.unregisterSnapshotListeners()
        bidFirestoreDAO.unregisterSnapshotListeners()
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        
        print(article)
        
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
    
    // MARK: Local helpers
    
    private func addArticle(_ articleToAdd: Article) {
        articles.append(articleToAdd)
        bidFirestoreDAO.registerSnapshotListener(ForArticle: articleToAdd, onSnapshot: bidSnapshotCallback)
        tableView.reloadData()
    }
    
    private func updateArticle(_ articleToUpdate: Article) {
        let index: Int? = articles.firstIndex(where: { article in
            return article.id == articleToUpdate.id
        })
        
        if let index = index {
            articles[index] = articleToUpdate
        } else {
            articles.append(articleToUpdate)
        }
    
        tableView.reloadData()
    }
    
    private func removeArticle(_ articleToRemove: Article) {
        articles.removeAll(where: { article in
            return article.id == articleToRemove.id
        })
        tableView.reloadData()
    }
}

//
//  ArticleListTableViewController.swift
//  ios-apps-opdracht-6
//
//  Created by student on 12/12/2018.
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit

class ArticleListTableViewController: UITableViewController {

    // MARK: Instance variables
    
    private lazy var articleDAO: ArticleDAO = ArticleDAO()
    private var articles: [Article] = [Article]()
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadArticles()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)

        cell.textLabel?.text = articles[indexPath.row].description

        return cell
    }
    
    // MARK: Local helper methods
    
    private func loadArticles() {
        
        articleDAO.getAll(onFinished: {(articles, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            self.articles = articles
        })
    }
}

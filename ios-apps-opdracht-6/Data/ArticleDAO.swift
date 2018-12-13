//
//  ArticleDAO.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class ArticleDAO: DAO {
    typealias T = Article
    
    private lazy var firestore: Firestore = {
        let database = Firestore.firestore()
        let settings = database.settings
        settings.areTimestampsInSnapshotsEnabled = true
        database.settings = settings
        return database
    }()
    
    private lazy var articleExtractor: ArticleExtractor = ArticleExtractor()
    
    func create(_ element: Article, onFinished: ((_ error: String?) -> Void)?) {
        // TODO
    }
    
    func getAll(onFinished: ((_ queryResults: [Article], _ error: String?) -> Void)?) {

        firestore.collection("Article").getDocuments(completion: {(querySnapshot, error) in
            if error != nil {
                return
            }
            
            var articles: [Article] = [Article]()
            
            querySnapshot?.documents.forEach({queryDocumentSnapshot in
                
                var article: Article = self.articleExtractor.extractElement(queryDocumentSnapshot)!
                
                print(article)
                
                articles.append(article)
                
                queryDocumentSnapshot.reference.collection("Bid").getDocuments(completion: {(subQuerySnapshot, subQueryError) in
                    if error != nil {
                        return
                    }
                    
                    subQuerySnapshot?.documents.forEach({subQuerySnapshotDocumentSnapshot in
                        print(subQuerySnapshotDocumentSnapshot.data())
                    })
                })
            })
        })
    }
}

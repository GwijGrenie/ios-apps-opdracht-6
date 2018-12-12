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
    
    private lazy var firestore = Firestore.firestore()
    
    func create(_ element: Article, onFinished: ((_ error: String?) -> Void)?) {
        // TODO
    }
    
    func getAll(onFinished: ((_ queryResults: [Article], _ error: String?) -> Void)?) {
        firestore.collection("Article").getDocuments(completion: {(querySnapshot, error) in
            if error != nil {
                return
            }
            
            var articles: [Article]
            
            querySnapshot?.documents.forEach({queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                
                queryDocumentSnapshot.data()
            })
        })
    }
}

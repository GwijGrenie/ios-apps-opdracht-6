//
//  BidFirestoreDAO.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

class BidFirestoreDAO {
    
    // MARK: Typealiases
    
    typealias GetAllCallback = (_ article: Article?, _ bids: [Bid]?, _ error: String?) -> Void
    typealias SnapshotListenerCallback = (_ article: Article?, _ querySnapshot: QuerySnapshot?, _ error: String?) -> Void
    
    // MARK: Read-only properties
    
    let collectionName: String = "Article"
    let subcollectionName: String = "Bid"
    
    // MARK: Instance variables
    
    private lazy var firestore: Firestore = Firestore.firestore()
    private var articleIdToListenerRegistrationMapping: [String: ListenerRegistration]
    
    // MARK: Initializors
    
    init () {
        articleIdToListenerRegistrationMapping = [String: ListenerRegistration]()
    }
    
    // MARK: Public methods
    
    func getAllAsync(ForArticle article: Article, onFinished: GetAllCallback?) {
        firestore.collection(collectionName).document(article.id).collection(subcollectionName).getDocuments(completion: { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                onFinished?(nil, nil, error!.localizedDescription)
                return
            }
            
            var bids: [Bid] = [Bid]()
            
            querySnapshot.documents.forEach({ document in
                bids.append(Bid(document))
            })
            
            onFinished?(article, bids, nil)
        })
    }
    
    func registerSnapshotListener(ForArticle article: Article, onSnapshot: SnapshotListenerCallback?) {
        let listenerRegistration: ListenerRegistration = firestore.collection(collectionName).document(article.id).collection(subcollectionName).addSnapshotListener({ querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                onSnapshot?(nil, nil, error!.localizedDescription)
                return
            }
            
            onSnapshot?(article, querySnapshot, nil)
        })
        
        articleIdToListenerRegistrationMapping[article.id] = listenerRegistration
    }
    
    func unregisterSnapshotListeners() {
        articleIdToListenerRegistrationMapping.forEach({ articleId, listenerRegistration in
            listenerRegistration.remove()
        })
        
        articleIdToListenerRegistrationMapping = [String: ListenerRegistration]()
    }
    
    func unregisterSnapshotListeners(ForArticle article: Article) {
        let articleId = article.id
        articleIdToListenerRegistrationMapping[articleId]?.remove()
        articleIdToListenerRegistrationMapping.removeValue(forKey: articleId)
    }
}

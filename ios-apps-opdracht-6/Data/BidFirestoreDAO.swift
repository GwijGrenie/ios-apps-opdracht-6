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
    
    typealias SnapshotListenerCallback = ((_ article: Article?, _ querySnapshot: QuerySnapshot?, _ error: String?) -> Void)
    
    // MARK: Read-only properties
    
    let collectionName: String = "Article"
    let subcollectionName: String = "Bid"
    
    // MARK: Instance variables
    
    private lazy var firestore: Firestore = Firestore.firestore()
    private var registeredListeners: [ListenerRegistration]
    
    // MARK: Initializors
    
    init () {
        registeredListeners = [ListenerRegistration]()
    }
    
    // MARK: Public methods
    
    func registerSnapshotListener(ForArticle article: Article, onSnapshot: SnapshotListenerCallback?) {
        let listenerRegistration: ListenerRegistration = firestore.collection(collectionName).document(article.id).collection(subcollectionName).addSnapshotListener({ querySnapshot, error in
            
            guard let querySnapshot = querySnapshot else {
                onSnapshot?(nil, nil, error!.localizedDescription)
                return
            }
            
            onSnapshot?(article, querySnapshot, nil)
        })
        
        registeredListeners.append(listenerRegistration)
    }
    
    func unregisterSnapshotListeners() {
        registeredListeners.forEach({ registeredListener in
            registeredListener.remove()
        })
    }
}

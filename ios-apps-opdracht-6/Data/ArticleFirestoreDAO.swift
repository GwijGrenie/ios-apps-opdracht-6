//
//  ArticleDAO.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

class ArticleFirestoreDAO {
    
    // MARK: Typealisases
    
    typealias SnapshotListenerCallback = ((_ querySnapshot: QuerySnapshot?, _ localizedError: String?) -> Void )

    // MARK: Read-only properties
    
    let collectionName: String = "Article"

    // MARK: Instance variables
    
    private lazy var firestore: Firestore = Firestore.firestore()
    private var registeredListeners: [ListenerRegistration]
    
    // MARK: Initializors
    
    init () {
        registeredListeners = [ListenerRegistration]()
    }
    
    // MARK: Public methods
    
    func registerSnapshotListener(onSnapshot: SnapshotListenerCallback?) {
        let listenerRegistration: ListenerRegistration = firestore.collection(collectionName).addSnapshotListener({ querySnapshot, error in
            
            guard let querySnapshot = querySnapshot else {
                onSnapshot?(nil, error!.localizedDescription)
                return
            }
            
            onSnapshot?(querySnapshot, nil)
        })
        
        registeredListeners.append(listenerRegistration)
    }
    
    func unregisterSnapshotListeners() {
        registeredListeners.forEach({registeredListener in
            registeredListener.remove()
        })
    }
}

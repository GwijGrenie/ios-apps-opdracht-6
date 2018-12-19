//
//  MemberDAO.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

class MemberFirestoreDAO {
        
    // MARK: Read-only properties
    
    let collectionName: String = "Member"
    
    // MARK: Instance variables
    
    private lazy var firestore: Firestore = Firestore.firestore()
    
    // MARK: Public functions
    
    func create(_ element: Member, onFinished: ((_ error: String?) -> Void)?) {
        firestore.collection(collectionName).addDocument(data: element.getData()) { error in
            if error != nil {
                onFinished?(error!.localizedDescription)
                return
            }
            
            onFinished?(nil)
        }
    }
}

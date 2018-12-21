//
//  MemberDAO.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

class MemberFirestoreDAO {
    
    // MARK: Typealiases
    
    typealias CreateCallback = (_ localizedError: String?) -> Void
    typealias GetCallback = (_ member: Member?, _ localizedError: String?) -> Void
    
    // MARK: Read-only properties
    
    let collectionName: String = "Member"
    
    // MARK: Instance variables
    
    private lazy var firestore: Firestore = Firestore.firestore()
    
    // MARK: Public functions
    
    func createAsync(_ member: Member, onFinished: CreateCallback?) {
        firestore.collection(collectionName).addDocument(data: member.getData()) { error in
            if error != nil {
                onFinished?(error!.localizedDescription)
                return
            }
            
            onFinished?(nil)
        }
    }
    
    func getAsync(WhereUID uid: String, onFinished: GetCallback?) {
        firestore.collection(collectionName).whereField("uid", isEqualTo: uid).getDocuments(completion: { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                onFinished?(nil, error!.localizedDescription)
                return
            }
            
            if querySnapshot.documents.isEmpty {
                onFinished?(nil, nil)
                return
            }
            
            onFinished?(Member(querySnapshot.documents.first!), nil)
        })
    }
}

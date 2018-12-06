//
//  MemberDAO.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class MemberDAO: DAO {
    typealias T = Member
    
    private lazy var firestore = Firestore.firestore()
    
    func create(_ element: Member, onFinished: ((_ error: String?) -> Void)?) {
        firestore.collection("Member").addDocument(data: [
            "name": element.name,
            "birthday": element.birthday,
            "uuid": element.uid
        ]) { error in
            if error != nil {
                onFinished?(error!.localizedDescription)
                return
            }
            
            onFinished?(nil)
        }
    }
}

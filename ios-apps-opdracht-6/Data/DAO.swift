//
//  DAO.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

protocol DAOCreateDelegate {
    func onCreateOperationFinished(error: String?)
}

protocol DAO {
    associatedtype T
    func create(_ element: T, onFinished: ((_ error: String?) -> Void)?)
}

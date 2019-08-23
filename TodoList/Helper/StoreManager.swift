//
//  StoreManager.swift
//  TodoList
//
//  Created by ThuTrangT5 on 8/22/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import Firebase

class StoreManager: NSObject {
    
    static let shared: StoreManager = StoreManager()
    static let COLLECTION = "todoList"
    
    override init() {
        super.init()
        FirebaseApp.configure()
    }
    
    func getTodoItems(status: TodoStatus, callback: (([TodoItem]?, Error?)->Void)?) {
        
        let ref = Firestore.firestore().collection(StoreManager.COLLECTION)
        var query: Query?
        if status != .all {
            query = ref.whereField("status", isEqualTo: status.rawValue).order(by: "created")
        } else {
            query = ref.order(by: "status").order(by: "created")
        }
        query?
            .getDocuments { (snapshot, error) in
                
                if let error = error {
                    callback?(nil, error)
                } else {
                    let items = snapshot.flatMap({ (query) -> [TodoItem] in
                        
                        var items: [TodoItem] = []
                        
                        for i in query.documents {
                            let dict = i.data()
                            let item = TodoItem(identifier: i.reference.documentID, dictionary: dict)
                            items.append(item)
                        }
                        return items
                    })
                    
                    callback?(items, error)
                }
        }
    }
    
    func addTodoItem(name: String, callback: ((TodoItem?, Error?) -> Void)?) {
        // Add a new document with a generated ID
        
        let documentData: [String: Any] = [
            "name": name,
            "status": TodoStatus.active.rawValue,
            "created": Date().timeIntervalSince1970
        ]
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore()
            .collection(StoreManager.COLLECTION)
            .addDocument(data: documentData) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    callback?(nil, err)
                    
                } else if let docRef = ref {
                    print("Document added with ID: \(docRef.documentID)")
                    let item = TodoItem(identifier: docRef.documentID, dictionary: documentData)
                    callback?(item, nil)
                }
        }
    }
    
    func removeTodoItem(itemID: String, callback: ((Error?)->Void)?) {
        
        Firestore.firestore()
            .collection(StoreManager.COLLECTION)
            .document(itemID)
            .delete() { error in
                callback?(error)
        }
    }
    
    func updateStatus(itemID: String, newStatus: TodoStatus, callback: ((Error?) -> Void)?) {
        Firestore.firestore()
            .collection(StoreManager.COLLECTION)
            .document(itemID)
            .updateData([
                "status": newStatus.rawValue
            ]) { error in
                callback?(error)
        }
    }
    
    func updateStatus(itemIDs: [String], newStatus: TodoStatus, callback: ((Error?) -> Void)?) {
        
        let db = Firestore.firestore()
        
        // Get new write batch
        let batch = db.batch()
        
        for id in itemIDs {
            let ref = db.collection(StoreManager.COLLECTION).document(id)
            batch.updateData(["status": newStatus.rawValue], forDocument: ref)
        }
        
        // Commit the batch
        batch.commit { (error) in
            callback?(error)
        }
    }
    
    func changeStatus(items: [TodoItem], callback: ((Error?) -> Void)?) {
        let db = Firestore.firestore()
        
        // Get new write batch
        let batch = db.batch()
        
        for item in items {
            guard let itemID = item.id else {
                continue
            }
            
            let newStatus: TodoStatus = (item.status == .done) ? .active : .done
            let ref = db.collection(StoreManager.COLLECTION).document(itemID)
            batch.updateData(["status": newStatus.rawValue], forDocument: ref)
        }
        
        // Commit the batch
        batch.commit { (error) in
            callback?(error)
        }
    }
}

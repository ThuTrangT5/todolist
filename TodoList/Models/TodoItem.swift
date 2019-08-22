//
//  TodoModel.swift
//  TodoList
//
//  Created by ThuTrangT5 on 8/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import Firebase

class TodoItem: NSObject {
    
    var id: String?
    var name: String?
    var status: TodoStatus = .active
    
    init(name: String) {
        super.init()
        self.id = "\(UUID())"
        self.name = name
        self.status = .active
    }
    
    init(document: DocumentReference) {
        self.id = document.documentID
        //        self.name = document["name"]
    }
    
    init(identifier: String, dictionary: [String: Any]) {
        self.id = identifier
        self.name = dictionary["name"] as? String
        if let statusName = dictionary["status"] as? String,
            statusName == TodoStatus.done.rawValue {
            self.status = TodoStatus.done
        } else {
            self.status = TodoStatus.active
        }
    }
    
}

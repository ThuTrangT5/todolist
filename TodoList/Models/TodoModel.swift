//
//  TodoModel.swift
//  TodoList
//
//  Created by ThuTrangT5 on 8/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class TodoModel: NSObject {

    var id: String?
    var name: String?
    var status: TodoStatus = .active
    
    init(name: String) {
        super.init()
        self.id = "\(UUID())"
        self.name = name
        self.status = .active
    }
    
}

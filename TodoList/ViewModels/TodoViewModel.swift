//
//  TodoViewModel.swift
//  TodoList
//
//  Created by ThuTrangT5 on 8/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import RxSwift
import RxCocoa

class TodoViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    public let loading: PublishSubject<Bool> = PublishSubject<Bool>()
    public let error : PublishSubject<String> = PublishSubject<String>()
    
    var todoList: BehaviorSubject<[TodoModel]> = BehaviorSubject<[TodoModel]>(value: [])
    var selectedStatus: BehaviorSubject<TodoStatus> = BehaviorSubject<TodoStatus>(value: TodoStatus.all)
    
    override init() {
        super.init()
        self.setupBinding()
    }
    
    func setupBinding() {
        self.selectedStatus
            .subscribe(onNext: { (newStatus) in
                
            })
        .disposed(by: disposeBag)
    }
    
    func insertTodoItem(name: String) {
        
        let newObject = TodoModel(name: name)
        guard var currentList = try? self.todoList.value() else { return }
        currentList.append(newObject)
        self.todoList.onNext(currentList)
    }
    
    func updateStatus(todoIDs: [String], newStatus: TodoStatus) {
        guard let currentList = try? self.todoList.value() else { return }
        
        for model in currentList {
            
            if let identifier = model.id,
                todoIDs.contains(identifier) {
                model.status = newStatus
            }
        }
    }
    
}

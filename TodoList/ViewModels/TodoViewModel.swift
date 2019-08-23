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
    
    var todoList: BehaviorSubject<[TodoItem]> = BehaviorSubject<[TodoItem]>(value: [])
    var selectedStatus: BehaviorSubject<TodoStatus> = BehaviorSubject<TodoStatus>(value: TodoStatus.all)
    
    override init() {
        super.init()
        self.setupBinding()
        self.getTodoList()
    }
    
    func setupBinding() {
        self.selectedStatus
            .subscribe(onNext: { [weak self](newStatus) in
                self?.getTodoList()
            })
            .disposed(by: disposeBag)
    }
    
    func insertTodoItem(name: String) {
        
        StoreManager.shared
            .addTodoItem(name: name) { [weak self](item, error) in
                if let errMessage = error?.localizedDescription {
                    self?.error.onNext(errMessage)
                    
                } else if let item = item,
                    let currentStatus = try? self?.selectedStatus.value(),
                    currentStatus == .all || currentStatus == .active {
                    // only update list item if selected status is NOT DONE
                    guard var currentList = try? self?.todoList.value() else { return }
                    currentList.append(item)
                    self?.todoList.onNext(currentList)
                }
        }
    }
    
    func updateStatus(todoIDs: [String], newStatus: TodoStatus) {

        self.loading.onNext(true)
        StoreManager.shared
            .updateStatus(itemIDs: todoIDs, newStatus: newStatus) { [weak self](error) in
                self?.loading.onNext(false)
                if let errMessage = error?.localizedDescription {
                    self?.error.onNext(errMessage)
                } else {
                    self?.getTodoList()
                }
        }
    }
    
    func deleteItem(itemID: String) {
        self.loading.onNext(true)
        StoreManager.shared
            .removeTodoItem(itemID: itemID) { [weak self](error) in
                self?.loading.onNext(false)
                if let errMessage = error?.localizedDescription {
                    self?.error.onNext(errMessage)
                } else {
                    self?.deleteLocalItem(itemID: itemID)
                }
        }
    }
    
    func getTodoList() {
        let status = (try? self.selectedStatus.value()) ?? TodoStatus.all
        self.loading.onNext(true)
        
        StoreManager.shared
            .getTodoItems(status: status) { [weak self](items, error) in
                self?.loading.onNext(false)
                
                if let items = items {
                    self?.todoList.onNext(items)
                } else if let errMessage = error?.localizedDescription {
                    self?.error.onNext(errMessage)
                }
        }
    }
    
    func changeTodoStatusBySelectedIndexes(indexes: [Int]) {
        self.loading.onNext(true)
        
        var items: [TodoItem] = []
        let currentList = (try? self.todoList.value()) ?? []
        
        for i in indexes {
            items.append(currentList[i])
        }
        
        StoreManager.shared
            .changeStatus(items: items) { [weak self](error) in
                 self?.loading.onNext(false)
                if let errMessage = error?.localizedDescription {
                    self?.error.onNext(errMessage)
                } else {
                    self?.getTodoList()
                }
        }
    }
    
    // MARK:- Private function
    
//    private func updateLocalItem(itemIDs: [String]) {
//        let currentList = (try? self.todoList.value()) ?? []
//
//        for i in 0..<currentList.count {
//            let item = currentList[i]
//            if item.id == itemID {
//                currentList.remove(at: i)
//                break
//            }
//        }
//
//        self.todoList.onNext(currentList)
//    }
    
    private func deleteLocalItem(itemID: String) {
        var currentList = (try? self.todoList.value()) ?? []
        
        for i in 0..<currentList.count {
            let item = currentList[i]
            if item.id == itemID {
                currentList.remove(at: i)
                break
            }
        }
        
        self.todoList.onNext(currentList)
    }
}

//
//  ViewController.swift
//  TodoList
//
//  Created by ThuTrangT5 on 8/21/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonToggleAll: UIButton!
    @IBOutlet weak var segmentFilter: UISegmentedControl!
    let refresh: UIRefreshControl = UIRefreshControl()
    
    var viewModel: TodoViewModel = TodoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.setupRx()
    }
    
    func setupUI() {
        let tinColor = UIColor(red: 255.0/255.0, green: 157.0/255.0, blue: 4.0/255.0, alpha: 1)
        self.textField.delegate = self
        
        self.buttonToggleAll.layer.cornerRadius = 10
        self.buttonToggleAll.layer.borderColor = tinColor.cgColor
        self.buttonToggleAll.layer.borderWidth = 1
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.refresh.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
        self.refresh.tintColor = tinColor
        self.tableView.addSubview(self.refresh)
    }

    func setupRx() {
        // text field
        self.textField.rx
            .controlEvent(UIControl.Event.editingDidEnd)
            .subscribe(onNext: { [weak self]() in
                if let text = self?.textField.text, text.count > 5 {
                    self?.viewModel.insertTodoItem(name: text)
                    self?.textField.text = nil // clear text
                }
            })
            .disposed(by: disposeBag)
        
        // table view
        self.viewModel.todoList
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: TodoTableViewCell.self)) { (row, model, cell) in
                cell.todoItem = model
            }
        .disposed(by: disposeBag)
        
        // animation to display
        self.tableView.rx
            .willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            }))
            .disposed(by: disposeBag)
        
    }
    
    @objc func reloadData() {
        self.refresh.endRefreshing()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

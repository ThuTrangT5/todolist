//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by ThuTrangT5 on 8/22/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewStatus: UIImageView!
    
    var deleteItemHandler: ((String)->Void)? = nil
    var updateItemHandler: ((String)->Void)? = nil
    
    var todoItem: TodoItem? {
        didSet {
            self.bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupStatusUI() {
        let status = self.todoItem?.status ?? .active
        self.imageViewStatus.image = (status == .active)
            ? UIImage(named: "ic_unselected")
            : UIImage(named: "ic_selected")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    func bindData() {
        self.setupStatusUI()
        self.labelTitle.text = self.todoItem?.name
    }
    
    @IBAction func ontouchStatus(_ sender: Any) {
        if let currentStatus = self.todoItem?.status,
            currentStatus == .active,
            let itemID = self.todoItem?.id {
            self.todoItem?.status = .done
            self.setupStatusUI()
            self.updateItemHandler?(itemID)
        }
    }
    
    @IBAction func ontouchDelete(_ sender: Any) {
        if let itemID = self.todoItem?.id {
            self.deleteItemHandler?(itemID)
        }
    }
}

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
    
    var todoItem: TodoModel? {
        didSet {
            self.bindData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let status = self.todoItem?.status ?? .active
        self.imageViewStatus.image = (status == .active)
            ? UIImage(named: "ic_unselected")
            : UIImage(named: "ic_selected")
    }
    
    func bindData() {
        let status = self.todoItem?.status ?? .active
        self.imageViewStatus.image = (status == .active)
            ? UIImage(named: "ic_unselected")
            : UIImage(named: "ic_selected")
        
        self.labelTitle.text = self.todoItem?.name
    }
    
    @IBAction func ontouchStatus(_ sender: Any) {
        if let currentStatus = self.todoItem?.status,
            currentStatus == .active {
            self.todoItem?.status = .done
        }
    }
}

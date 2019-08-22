//
//  UIViewController+Loading.swift
//  TodoList
//
//  Created by ThuTrangT5 on 8/22/19.
//  Copyright © 2019 ThuTrangT5. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoadingViewable {
    func startAnimating()
    func stopAnimating()
    func showErrorMessage(message: String)
}
extension LoadingViewable where Self : UIViewController {
    func startAnimating(){
        if let activityLoader = self.view.viewWithTag(999) as? UIActivityIndicatorView {
            activityLoader.startAnimating()
            return
        }
        
        let activityLoader = UIActivityIndicatorView(style: .gray)
        activityLoader.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityLoader.center = self.view.center
        activityLoader.tag = 999
        activityLoader.tintColor = UIColor(red: 255.0/255.0, green: 157.0/255.0, blue: 4.0/255.0, alpha: 1)
        self.view.addSubview(activityLoader)
        activityLoader.startAnimating()
    }
    func stopAnimating() {
        if let activityLoader = self.view.viewWithTag(999) as? UIActivityIndicatorView {
            activityLoader.stopAnimating()
            activityLoader.removeFromSuperview()
        }
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: LoadingViewable {}

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
}




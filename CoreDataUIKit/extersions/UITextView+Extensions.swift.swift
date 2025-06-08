//
//  UITextView+Extensions.swift.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/8.
//


import UIKit

extension UITextView {
    func withPadding(top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0,left: CGFloat = 0) -> UIView {
        let labelWrapperView = UIView()
        labelWrapperView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false // MARK: "我要手动管理约束"
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: labelWrapperView.topAnchor, constant: top),
            self.leadingAnchor.constraint(equalTo: labelWrapperView.leadingAnchor, constant: left),
            self.trailingAnchor.constraint(equalTo: labelWrapperView.trailingAnchor, constant: -right),
            self.bottomAnchor.constraint(equalTo: labelWrapperView.bottomAnchor, constant: -bottom)
        ])
        
        return labelWrapperView
    }
}

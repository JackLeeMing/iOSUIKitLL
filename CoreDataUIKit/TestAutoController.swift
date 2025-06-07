//
//  TestAutoController.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/7.
//

import UIKit

class TestAutoController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let view1 = UIView()
        view1.backgroundColor = .red
        view1.translatesAutoresizingMaskIntoConstraints = false
        let view2 = UIView()
        view2.backgroundColor = .green
        view2.translatesAutoresizingMaskIntoConstraints = false
        let view3 = UIView()
        view3.backgroundColor = .blue
        view3.translatesAutoresizingMaskIntoConstraints = false
        
        let view4 = UIView()
        view4.backgroundColor = .systemPink
        view4.translatesAutoresizingMaskIntoConstraints = false
        let view5 = UIView()
        view5.backgroundColor = .brown
        view5.translatesAutoresizingMaskIntoConstraints = false
        
        let view6 = UIView()
        view6.backgroundColor = .orange
        view6.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        view.addSubview(view4)
        view.addSubview(view5)
        view.addSubview(view6)
        
        NSLayoutConstraint.activate([
            view1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            view1.heightAnchor.constraint(equalToConstant: 38),
            
            view2.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 8),
            view2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view2.heightAnchor.constraint(equalToConstant: 32),
            
            view3.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 8),
            view3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            view3.heightAnchor.constraint(equalToConstant: 32),
            view2.rightAnchor.constraint(equalTo: view3.leftAnchor, constant: -8),
            
            view2.widthAnchor.constraint(equalTo: view3.widthAnchor, multiplier: 1),
            
            view4.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 8),
            view4.heightAnchor.constraint(equalToConstant: 36),
            view4.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            view5.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 8),
            view5.heightAnchor.constraint(equalToConstant: 36),
            
            view6.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 8),
            view6.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            view6.heightAnchor.constraint(equalToConstant: 36),
            
            view4.rightAnchor.constraint(equalTo: view5.leftAnchor, constant: -8),
            view5.rightAnchor.constraint(equalTo: view6.leftAnchor, constant: -8),
            
            view4.widthAnchor.constraint(equalTo: view5.widthAnchor, multiplier: 0.5),
            view4.widthAnchor.constraint(equalTo: view6.widthAnchor, multiplier: 1),
        ])
    }
}

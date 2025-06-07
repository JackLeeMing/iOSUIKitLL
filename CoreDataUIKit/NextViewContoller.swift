//
//  NextViewContoller.swift
//  CoreDataUIKit
// MARK:  直接将swiftUI 的视图嵌入到UIKit中
//  Created by 李嘉魁 on 2025/6/3.
//

import UIKit
import SwiftUI

class NextViewContoller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 直接将swiftUI 的视图嵌入到UIKit中
        let swiftUIView = ContentView{[weak self] in self?.dismiss(animated: true)}
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        // 设置约束
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}

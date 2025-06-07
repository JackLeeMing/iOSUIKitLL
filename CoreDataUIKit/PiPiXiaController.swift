//
//  ViewController.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/3.
//

import UIKit
import SwiftUI

class PiPiXiaController: UIViewController {
    @IBOutlet weak var myButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "皮皮虾"
    }
    
    @IBAction func navigateButtonTapped(_ sender: UIButton) {
           navigateToDestination()
    }

    @IBAction func navigateButtonTapped2(_ sender: UIButton){
        let swiftUIView = ContentView(onDismiss: nil) // 不需要传递闭包
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.modalPresentationStyle = .popover
        present(hostingController, animated: true)
    }
    
    // MARK: 直接展示SiwftUI
    private func navigateToDestination() {
        let destinationVC = NextViewContoller()
        let navigationController = UINavigationController(rootViewController: destinationVC)
        // Modal 呈现整个导航流程
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true)
    }
}


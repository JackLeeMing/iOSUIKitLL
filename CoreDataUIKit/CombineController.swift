//
//  CombineController.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/7.
//
import UIKit
import Combine

class MyViewModel: ObservableObject {
    @Published var counter = 0
    private var cancellables = Set<AnyCancellable>()
    init(){
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
        // Subscribe to the timer publisher and update the counter
        timerPublisher.sink { [weak self] _ in
            self?.counter += 1
        }.store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

class CombineController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = MyViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        
        let labelContainerView = UIView()
        labelContainerView.backgroundColor = UIColor.red
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.backgroundColor = UIColor.yellow
        
        labelContainerView.addSubview(label)
        // 先添加到视图 再设置约束
        view.addSubview(labelContainerView)
        
        NSLayoutConstraint.activate([
            labelContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 20),
            // 约束的方向
            // 正值情况（向右/向下）
            label.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor, constant: -16)
        ])
        
        viewModel.$counter
            .receive(on: DispatchQueue.main)
            .sink { count in
                label.text = "counter:\(count)"
                print(count)
            }.store(in: &cancellables)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cancellables.removeAll()
    }
}

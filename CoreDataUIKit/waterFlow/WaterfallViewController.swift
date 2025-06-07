//
//  WaterfallViewController.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/6.
//

import UIKit

// 数据模型
struct WaterfallItem {
    let title: String
    let imageName: String
    let height: CGFloat
    let backgroundColor: UIColor
}

class WaterfallViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 瀑布流布局
    private let waterfallLayout = WaterfallLayout()
    
    // 测试数据
    private var items: [WaterfallItem] = [
        WaterfallItem(title: "美食1", imageName: "food1", height: 200, backgroundColor: .systemPink),
        WaterfallItem(title: "风景2", imageName: "landscape2", height: 150, backgroundColor: .systemBlue),
        WaterfallItem(title: "动物3", imageName: "animal3", height: 250, backgroundColor: .systemGreen),
        WaterfallItem(title: "建筑4", imageName: "building4", height: 180, backgroundColor: .systemOrange),
        WaterfallItem(title: "艺术5", imageName: "art5", height: 220, backgroundColor: .systemPurple),
        WaterfallItem(title: "自然6", imageName: "nature6", height: 160, backgroundColor: .systemTeal),
        WaterfallItem(title: "科技7", imageName: "tech7", height: 240, backgroundColor: .systemIndigo),
        WaterfallItem(title: "运动8", imageName: "sport8", height: 190, backgroundColor: .systemRed),
        WaterfallItem(title: "音乐9", imageName: "music9", height: 210, backgroundColor: .systemYellow),
        WaterfallItem(title: "电影10", imageName: "movie10", height: 170, backgroundColor: .systemGray),
        WaterfallItem(title: "游戏11", imageName: "game11", height: 230, backgroundColor: .systemMint),
        WaterfallItem(title: "时尚12", imageName: "fashion12", height: 200, backgroundColor: .systemCyan)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    private func setupCollectionView() {
        // 设置自定义布局
        waterfallLayout.delegate = self
        waterfallLayout.minimumLineSpacing = 10
        waterfallLayout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = waterfallLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.systemBackground
        
        // 注册 cell
        collectionView.register(WaterfallCell.self, forCellWithReuseIdentifier: "WaterfallCell")
    }
    
    private func setupNavigationBar() {
        title = "瀑布流"
        
        // 添加切换列数的按钮
        let twoColumnsButton = UIBarButtonItem(title: "2列", style: .plain, target: self, action: #selector(setTwoColumns))
        let threeColumnsButton = UIBarButtonItem(title: "3列", style: .plain, target: self, action: #selector(setThreeColumns))
        
        navigationItem.rightBarButtonItems = [threeColumnsButton, twoColumnsButton]
    }
    
    @objc private func setTwoColumns() {
        waterfallLayout.setNumberOfColumns(2)
    }
    
    @objc private func setThreeColumns() {
        waterfallLayout.setNumberOfColumns(3)
    }
}

// MARK: - UICollectionViewDataSource
extension WaterfallViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterfallCell", for: indexPath) as! WaterfallCell
        
        let item = items[indexPath.item]
        cell.configure(with: item)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WaterfallViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        
        let alert = UIAlertController(title: "选中了", message: item.title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - WaterfallLayoutDelegate
extension WaterfallViewController: WaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        // 返回每个item的高度
        return items[indexPath.item].height
    }
}

// MARK: - 自定义 Cell
class WaterfallCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let backgroundImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 设置圆角
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        
        // 设置背景视图
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundImageView)
        
        // 设置标题标签
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        titleLabel.layer.cornerRadius = 8
        titleLabel.layer.masksToBounds = true
        
        let labelContainerView = titleLabel.addPadding(left: 20, right: 20)
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false // MARK: "我要手动管理约束"
        contentView.addSubview(labelContainerView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 背景视图填满整个 cell
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 标题标签位于底部中心
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with item: WaterfallItem) {
        titleLabel.text = item.title
        backgroundImageView.backgroundColor = item.backgroundColor
        
        // 如果有实际图片，可以这样设置：
        // backgroundImageView.image = UIImage(named: item.imageName)
    }
}

extension UILabel {
    func addPadding(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIView {
        let containerView = UIView()
        containerView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false // MARK: "我要手动管理约束"
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: top),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: left),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -right),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -bottom)
        ])
        
        return containerView
    }
}

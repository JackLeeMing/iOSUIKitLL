//
//  NextFeatureController.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/17.
//

import UIKit
import Alamofire
import SDWebImage

class NextFeatureController: UIViewController {
    
    // MARK: - Section 定义
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Properties
    var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Feature>!
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let statusLabel = UILabel()
    
    private var features: [Feature] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDataSource()
        Task {
            await loadFeatures()
        }
    }
    
    // MARK: - Setup UI
    func setupView() {
        view.backgroundColor = .systemBackground
        
        // 创建 Compositional Layout
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.delegate = self
        
        // 注册 cell
        collectionView.register(NextFeatureCell.self, forCellWithReuseIdentifier: "FeatureCell")
        
        // 设置状态标签
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textColor = .secondaryLabel
        statusLabel.text = "Loading..."
        
        loadingIndicator.hidesWhenStopped = true
        
        // 设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(statusLabel)
        
        loadingIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            // collectionView 约束
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loading Indicator 约束
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            // Status Label 约束
            statusLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Create Compositional Layout
    private func createLayout() -> UICollectionViewLayout {
        return WaterfallCompositionalLayout(numberOfColumns: 2, spacing: 5, contentInsets: NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
    }
    
    // MARK: - Setup DataSource
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Feature>(
            collectionView: collectionView
        ) { (collectionView, indexPath, feature) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FeatureCell",
                for: indexPath
            ) as! NextFeatureCell
            cell.configure(with: feature)
            return cell
        }
    }
    
    // MARK: - Update Data
    private func updateSnapshot(with features: [Feature], animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Feature>()
        snapshot.appendSections([.main])
        snapshot.appendItems(features, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    // MARK: - Loading State UI
    private func updateLoadingUI(isLoading: Bool, message: String = "Loading...") {
        if isLoading {
            loadingIndicator.startAnimating()
            statusLabel.text = message
            collectionView.isHidden = true
        } else {
            loadingIndicator.stopAnimating()
            statusLabel.text = message
            collectionView.isHidden = false
        }
    }
    
    // MARK: - Load Data
    @MainActor
    private func loadFeatures() async {
        updateLoadingUI(isLoading: true)
        let features = await NetworkService.shared.fetchFeatures()
        self.features = features
        print("✅ 获取到 \(features.count) 个数据")
        updateSnapshot(with: features)
        updateLoadingUI(isLoading: false, message: "Loaded \(features.count) posts")
    }
    
    deinit {
        print("NextFeatureController deinit")
    }
}

// MARK: - Custom Waterfall Compositional Layout
class WaterfallCompositionalLayout: UICollectionViewLayout {
    private let numberOfColumns: Int
    private let spacing: CGFloat
    private let contentInsets: NSDirectionalEdgeInsets
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width - contentInsets.leading - contentInsets.trailing
    }
    
    private var columnWidth: CGFloat {
        return (contentWidth - CGFloat(numberOfColumns - 1) * spacing) / CGFloat(numberOfColumns)
    }
    
    init(numberOfColumns: Int = 2, spacing: CGFloat = 5, contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)) {
        self.numberOfColumns = numberOfColumns
        self.spacing = spacing
        self.contentInsets = contentInsets
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.numberOfColumns = 2
        self.spacing = 5
        self.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        super.init(coder: coder)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth + contentInsets.leading + contentInsets.trailing,
                     height: contentHeight + contentInsets.top + contentInsets.bottom)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        contentHeight = 0
        
        // 记录每列的当前高度
        var columnHeights: [CGFloat] = Array(repeating: contentInsets.top, count: numberOfColumns)
        
        // 为每个 item 计算布局属性
        for section in 0..<collectionView.numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                
                // 找到最短的列
                let shortestColumnIndex = columnHeights.enumerated().min(by: { $0.1 < $1.1 })?.0 ?? 0
                
                // 计算 item 的位置
                let xOffset = contentInsets.leading + CGFloat(shortestColumnIndex) * (columnWidth + spacing)
                let yOffset = columnHeights[shortestColumnIndex]
                
                // 获取预估高度，这里可以根据实际需求调整
                let estimatedHeight = getEstimatedHeight(for: indexPath)
                
                let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: estimatedHeight)
                
                // 创建布局属性
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                // 更新列高度
                columnHeights[shortestColumnIndex] = frame.maxY + spacing
                
                // 更新内容总高度
                contentHeight = max(contentHeight, frame.maxY)
            }
        }
    }
    
    private func getEstimatedHeight(for indexPath: IndexPath) -> CGFloat {
        // 可以根据实际需求返回不同的高度
        // 这里返回一个基础高度，实际高度会在 cell 的 preferredLayoutAttributesFitting 中调整
        return 280 + CGFloat.random(in: -50...100) // 随机高度模拟不同内容长度
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item < cache.count else { return nil }
        return cache[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
}

// MARK: - UICollectionViewDelegate
extension NextFeatureController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let feature = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let alert = UIAlertController(title: "选中了", message: feature.title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewCell
class NextFeatureCell: UICollectionViewCell {
    private let containerView = UIView()
    private let titleLabel = UITextView()
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // 容器视图 - 包含所有内容
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // 设置阴影
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
        layer.masksToBounds = false
        
        // 设置背景视图
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(backgroundImageView)
        
        // 设置标题标签
        setupTitleLabel()
        
        // 设置约束
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .left
        titleLabel.layer.cornerRadius = 0
        titleLabel.layer.masksToBounds = true
        titleLabel.isEditable = false
        titleLabel.isScrollEnabled = false
        titleLabel.textContainerInset = .zero
        titleLabel.textContainer.lineFragmentPadding = 0
        titleLabel.backgroundColor = .clear
        titleLabel.textContainer.maximumNumberOfLines = 2
        titleLabel.textContainer.lineBreakMode = .byTruncatingTail
        
        let labelView = titleLabel.withPadding(top: 6, right: 3, left: 4)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.backgroundColor = UIColor.white
        containerView.addSubview(labelView)
    }
    
    private func setupConstraints() {
        let labelView = containerView.subviews.last! // titleLabel 的包装视图
        
        NSLayoutConstraint.activate([
            // 容器视图稍微内缩，留出阴影空间
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // 背景视图
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -38),
            
            // 标题标签位于底部
            labelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            labelView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            labelView.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    func configure(with item: Feature) {
        titleLabel.text = item.desc
        backgroundImageView.sd_setImage(with: URL(string: item.imageUrl))
    }
    
    // 重写此方法来支持动态高度计算
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        // 确保宽度固定
        let size = super.systemLayoutSizeFitting(
            CGSize(width: targetSize.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return CGSize(width: targetSize.width, height: max(size.height, 200)) // 最小高度 200
    }
}

// MARK: - Extension for Feature to conform to Hashable
extension Feature: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // 假设 Feature 有 id 属性
        // 如果没有 id，可以使用其他唯一标识符
        // hasher.combine(title)
        // hasher.combine(imageUrl)
    }
    
    static func == (lhs: Feature, rhs: Feature) -> Bool {
        return lhs.id == rhs.id // 假设 Feature 有 id 属性
        // 如果没有 id，可以比较其他属性
        // return lhs.title == rhs.title && lhs.imageUrl == rhs.imageUrl
    }
}

// MARK: - UITextView Padding Extension (如果还没有定义的话)
extension UITextView {
    func withPadding(top: CGFloat = 0, right: CGFloat = 0, left: CGFloat = 0) -> UIView {
        let containerView = UIView()
        containerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: top),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: left),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -right),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
}

//
//  FeatureController.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/8.
//

import UIKit
import Alamofire
import SDWebImage
import Toast
import SVProgressHUD

class FeatureController: UIViewController {
    private var fetchTask: Task<Void, Never>?
    var collectionView: UICollectionView?
    private var features: [Feature] = []
    private let featureLayout = FeatureLayout()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // self.view.makeToastActivity(.center)
        SVProgressHUD.show()
        Task {
          await fetchFeatures()
        }
    }
    
    func setUpView(){
        // waterfallLayout.delegate = self
        view.backgroundColor =  UIColor.systemBackground
        featureLayout.minimumLineSpacing = 5
        featureLayout.minimumInteritemSpacing = 5
        // featureLayout.delegate = self
        // collectionView = UICollectionView()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: featureLayout)
        collectionView!.backgroundColor = UIColor.systemBackground
        collectionView!.dataSource = self
        collectionView!.delegate = self
        // 注册 cell
        collectionView!.register(FeatureCell.self, forCellWithReuseIdentifier: "FeatureCell")
        collectionView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView!)
        NSLayoutConstraint.activate([
            collectionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchFeatures() async {
        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                defer {
                    SVProgressHUD.dismiss()
                }
                let res = try await AF.request("https://sua.h5lego.cn/api/v1/features?page=1&page_size=10")
                    .serializingDecodable(Res.self)
                    .value
                guard !Task.isCancelled else { return }
                // 确保在主线程更新 UI
                await MainActor.run { [weak self] in
                    // guard let self = self else { return }
                    if(res.code == "0"){
                        self?.features = res.data.data
                        print("✅ 获取到 \(String(describing: self?.features.count)) 个数据")
                        self?.collectionView?.reloadData()
                        self?.view.hideToastActivity()
                    } else {
                        print("❌ API 返回错误: \(res.message)")
                        self?.view.hideToastActivity()
                    }
                }
            } catch {
                print("❌ 网络请求错误: \(error)")
                guard !Task.isCancelled else { return }
                await MainActor.run {[weak self] in
                    self?.view.hideToastActivity()
                }
            }
        }

    }
    
    deinit {
        fetchTask?.cancel()
    }
}

// MARK: - UICollectionViewDataSource
extension FeatureController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCell", for: indexPath) as! FeatureCell
        let item = features[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FeatureController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = features[indexPath.item]
        let alert = UIAlertController(title: "选中了", message: item.title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

protocol FeatureLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

// 添加代理实现
extension FeatureController: FeatureLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        // 可以根据内容动态计算高度，或者返回固定高度
        return FeatureLayout.defaultItemHeight // 或者根据具体需求计算
    }
}

// MARK: - UICollectionViewLayout
class FeatureLayout: UICollectionViewFlowLayout {
    
    public static var defaultItemHeight:CGFloat = 300.0
    
    weak var delegate: FeatureLayoutDelegate?
    // 列数
    private var numberOfColumns = 2
    // 缓存所有item的布局属性
    private var cache: [UICollectionViewLayoutAttributes] = []
    // 内容高度
    private var contentHeight: CGFloat = 0
    // 内容宽度
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    // 返回整个collectionView的内容大小
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        // 清空缓存
        cache.removeAll()
        contentHeight = 0
        // 计算每列的宽度
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        // 记录每列当前的Y坐标
        var columnHeights: [CGFloat] = Array(repeating: 0, count: numberOfColumns)
        // 为每个item计算布局属性
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                // 获取item高度（通过代理）
                let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath) ?? FeatureLayout.defaultItemHeight
                // 找到最短的列
                let shortestColumn = columnHeights.enumerated().min(by: { $0.1 < $1.1 })?.0 ?? 0
                // 计算item的frame
                let xOffset = CGFloat(shortestColumn) * columnWidth
                let yOffset = columnHeights[shortestColumn]
                let frame = CGRect(
                    x: xOffset + minimumInteritemSpacing/2,
                    y: yOffset + (yOffset == 0 ? minimumLineSpacing : minimumLineSpacing),
                    width: columnWidth - minimumInteritemSpacing,
                    height: itemHeight
                )
                // 创建布局属性
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                // 更新该列的高度
                columnHeights[shortestColumn] = frame.maxY
                // 更新内容总高度
                contentHeight = max(contentHeight, frame.maxY)
            }
        }

    }
    
    // 返回指定区域内的所有item布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    // 返回指定indexPath的item布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    // 设置列数
    func setNumberOfColumns(_ columns: Int) {
        numberOfColumns = columns
        invalidateLayout()
    }
}

// MARK: - UICollectionViewCell
class FeatureCell: UICollectionViewCell {
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
    
    private func setupUI(){
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: titleLabel.font ?? UIFont.systemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle
        ]
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
        
        titleLabel.attributedText = NSAttributedString(string: "", attributes: attributes)
        titleLabel.textContainer.maximumNumberOfLines = 2
        titleLabel.textContainer.lineBreakMode = .byTruncatingTail
        titleLabel.isScrollEnabled = false
        
        let labelView = titleLabel.withPadding(top: 6, right: 3,left: 4)
        labelView.translatesAutoresizingMaskIntoConstraints = false // MARK: "我要手动管理约束"
        labelView.backgroundColor = UIColor.white
        containerView.addSubview(labelView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 容器视图稍微内缩，留出阴影空间
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            // 背景视图填满整个 cell
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -36),
            //FeatureLayout.defaultItemHeight
            
            // 标题标签位于底部中心
            // labelView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 2),
            labelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            labelView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            labelView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func configure(with item: Feature){
        titleLabel.text = item.desc
        // 如果有实际图片，可以这样设置：
        // backgroundImageView.image = UIImage(named: item.imageName)
        backgroundImageView.sd_setImage(with: URL(string: item.imageUrl))
    }
}

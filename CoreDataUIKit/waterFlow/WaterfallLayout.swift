//
//  WaterfallLayout.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/6.
//
import UIKit

protocol WaterfallLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class WaterfallLayout: UICollectionViewFlowLayout {
    
    weak var delegate: WaterfallLayoutDelegate?
    
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
    
    // 初始化设置
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
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 获取item高度（通过代理）
            let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath) ?? 180
            
            // 找到最短的列
            let shortestColumn = columnHeights.enumerated().min(by: { $0.1 < $1.1 })?.0 ?? 0
            
            // 计算item的frame
            let xOffset = CGFloat(shortestColumn) * columnWidth
            let yOffset = columnHeights[shortestColumn]
            
            let frame = CGRect(
                x: xOffset + minimumInteritemSpacing/2,
                y: yOffset + minimumLineSpacing,
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

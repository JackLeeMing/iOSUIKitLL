# iOS 系统级布局方案详解

## 🏗️ UICollectionView 布局系统

### 1. **UICollectionViewFlowLayout** 
**系统提供 | iOS 6.0+**

**用途**：最基础的网格布局，适合规则的行列排列
```swift
let layout = UICollectionViewFlowLayout()
layout.itemSize = CGSize(width: 100, height: 100)
layout.minimumLineSpacing = 10
layout.minimumInteritemSpacing = 10
layout.scrollDirection = .vertical
```

**特色**：
- ✅ 简单易用，无需自定义代码
- ✅ 支持水平/垂直滚动
- ✅ 支持 header/footer
- ❌ 只能创建规则网格
- ❌ 不支持复杂布局

**适用场景**：照片网格、商品列表、简单卡片布局

---

### 2. **UICollectionViewCompositionalLayout** 
**系统提供 | iOS 13.0+**

**用途**：现代化的复合布局系统，支持复杂的多层次布局
```swift
let layout = UICollectionViewCompositionalLayout { section, environment in
    // 为每个 section 返回不同的布局
    return createSectionLayout(for: section)
}
```

**特色**：
- ✅ 高度灵活，支持复杂布局组合
- ✅ 内置瀑布流支持（iOS 16+）
- ✅ 支持嵌套滚动
- ✅ 优秀的性能表现
- ✅ 支持 Orthogonal Scrolling
- ❌ 学习曲线较陡峭
- ❌ 需要 iOS 13+

**适用场景**：App Store 首页、复杂的内容展示、多样化布局需求

---

### 3. **自定义 UICollectionViewLayout**
**开发者实现 | iOS 6.0+**

**用途**：完全自定义的布局解决方案
```swift
class CustomLayout: UICollectionViewLayout {
    override func prepare() { /* 计算所有布局属性 */ }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? { /* 返回可见区域的属性 */ }
    override var collectionViewContentSize: CGSize { /* 返回内容大小 */ }
}
```

**特色**：
- ✅ 完全控制布局逻辑
- ✅ 可实现任意复杂效果
- ✅ 支持所有 iOS 版本
- ❌ 开发复杂度高
- ❌ 需要处理性能优化
- ❌ 容易出错

**适用场景**：特殊视觉效果、圆形布局、瀑布流、时间轴布局

---

## 📱 UITableView 布局系统

### 4. **UITableView + Dynamic Type**
**系统提供 | iOS 2.0+**

**用途**：列表式内容展示，支持动态高度
```swift
tableView.rowHeight = UITableView.automaticDimension
tableView.estimatedRowHeight = 100
```

**特色**：
- ✅ 自动处理滚动和回收
- ✅ 支持动态高度
- ✅ 内置编辑功能
- ✅ 优秀的性能
- ❌ 只支持单列布局
- ❌ 自定义能力有限

**适用场景**：设置页面、聊天列表、新闻列表、联系人

---

## 🎨 Auto Layout 约束系统

### 5. **Auto Layout**
**系统提供 | iOS 6.0+**

**用途**：基于约束的布局系统，适应不同屏幕尺寸
```swift
view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 20),
    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16)
])
```

**特色**：
- ✅ 响应式设计
- ✅ 支持所有 UI 组件
- ✅ 适配多设备
- ✅ Interface Builder 可视化支持
- ❌ 复杂约束可能导致性能问题
- ❌ 调试困难

**适用场景**：所有 UIKit 界面布局的基础

---

### 6. **UIStackView**
**系统提供 | iOS 9.0+**

**用途**：简化线性布局的容器视图
```swift
let stackView = UIStackView(arrangedSubviews: [label1, label2, button])
stackView.axis = .vertical
stackView.spacing = 10
stackView.distribution = .equalSpacing
```

**特色**：
- ✅ 简化线性布局代码
- ✅ 自动处理约束
- ✅ 支持嵌套
- ✅ 动态隐藏/显示子视图
- ❌ 只支持线性排列
- ❌ 复杂布局仍需额外约束

**适用场景**：表单布局、工具栏、按钮组、内容卡片

---

## 🆕 SwiftUI 布局系统

### 7. **SwiftUI Layout Protocol**
**系统提供 | iOS 16.0+**

**用途**：SwiftUI 中的自定义布局系统
```swift
struct WaterfallLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // 计算布局尺寸
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // 放置子视图
    }
}
```

**特色**：
- ✅ 声明式布局
- ✅ 类型安全
- ✅ 高性能
- ✅ 易于组合
- ❌ 仅限 SwiftUI
- ❌ 需要 iOS 16+

**适用场景**：SwiftUI 应用中的自定义布局需求

---

### 8. **SwiftUI 内置布局容器**
**系统提供 | iOS 13.0+**

**包含**：VStack, HStack, ZStack, LazyVGrid, LazyHGrid, Grid

```swift
LazyVGrid(columns: [
    GridItem(.flexible()),
    GridItem(.flexible())
]) {
    ForEach(items) { item in
        ItemView(item: item)
    }
}
```

**特色**：
- ✅ 零代码布局
- ✅ 自动优化性能
- ✅ 响应式设计
- ✅ 易于理解和维护
- ❌ 自定义能力有限
- ❌ 仅限 SwiftUI

---

## 📊 特殊用途布局

### 9. **NSCollectionLayoutSection (iOS 13+)**
**系统提供 | 用于 CompositionalLayout**

**用途**：定义 CompositionalLayout 中的 section 布局
```swift
// 瀑布流 section
let section = NSCollectionLayoutSection.list(using: .init(appearance: .plain), layoutEnvironment: environment)

// 横向滚动 section  
let section = NSCollectionLayoutSection(group: group)
section.orthogonalScrollingBehavior = .continuous
```

**特色**：
- ✅ 预设常用布局模式
- ✅ 支持正交滚动
- ✅ 内置 List 样式
- ❌ 依赖 CompositionalLayout

---

### 10. **UICollectionViewListLayout (iOS 14+)**
**系统提供**

**用途**：现代化的 List 布局，类似 TableView 但更灵活
```swift
let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
let layout = UICollectionViewCompositionalLayout.list(using: configuration)
```

**特色**：
- ✅ TableView 的灵活版本
- ✅ 支持 swipe actions
- ✅ 内置分组样式
- ✅ 与 DiffableDataSource 完美集成

---

## 🎯 布局选择指南

| 需求场景 | 推荐布局 | 理由 |
|---------|---------|------|
| 简单网格 | UICollectionViewFlowLayout | 简单高效 |
| 复杂多样化布局 | UICollectionViewCompositionalLayout | 现代化、灵活 |
| 列表 + 分组 | UICollectionViewListLayout | 现代 TableView 替代 |
| 传统列表 | UITableView | 成熟稳定 |
| 线性排列 | UIStackView | 简化约束 |
| 特殊效果 | 自定义 Layout | 完全控制 |
| SwiftUI 应用 | SwiftUI Layout | 原生支持 |

## 💡 最佳实践建议

1. **优先使用系统布局**：避免重复造轮子
2. **根据 iOS 版本选择**：新项目推荐 CompositionalLayout
3. **性能优先**：复杂布局考虑懒加载
4. **代码可维护性**：简单场景避免过度设计
5. **用户体验**：保持布局的一致性和可预测性
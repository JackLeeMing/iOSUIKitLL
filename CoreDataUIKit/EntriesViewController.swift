//
//  SettingsTableViewController.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/6.
//
import UIKit

struct SettingsSection {
    let title: String?
    let items: [SettingsItem]
}

struct SettingsItem {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor?
    let accessoryType: UITableViewCell.AccessoryType
}

class EntriesViewController: UITableViewController {
    // 分组数据
       let sections: [SettingsSection] = [
           // 第一组
           SettingsSection(title: nil, items: [
               SettingsItem(title: "Home",
                           icon: UIImage(systemName: "1.circle"),
                           iconBackgroundColor: .systemGray,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "Combine",
                           icon: UIImage(systemName: "2.circle"),
                           iconBackgroundColor: .systemBlue,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "Auto",
                           icon: UIImage(systemName: "3.circle"),
                           iconBackgroundColor: .systemBlue,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "Feature",
                           icon: UIImage(systemName: "4.circle"),
                           iconBackgroundColor: .black,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "Feature2",
                           icon: UIImage(systemName: "5.circle"),
                           iconBackgroundColor: .systemGray,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "相机",
                           icon: UIImage(systemName: "camera"),
                           iconBackgroundColor: .systemGray,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "主屏幕与 App 资源库",
                           icon: UIImage(systemName: "square.grid.3x3"),
                           iconBackgroundColor: .systemBlue,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "Apple智能与 Siri",
                           icon: UIImage(systemName: "sparkles"),
                           iconBackgroundColor: .systemPurple,
                           accessoryType: .disclosureIndicator)
           ]),
           
           // 第二组
           SettingsSection(title: nil, items: [
               SettingsItem(title: "屏幕使用时间",
                           icon: UIImage(systemName: "hourglass"),
                           iconBackgroundColor: .systemPurple,
                           accessoryType: .disclosureIndicator)
           ]),
           
           // 第三组
           SettingsSection(title: nil, items: [
               SettingsItem(title: "隐私与安全性",
                           icon: UIImage(systemName: "hand.raised"),
                           iconBackgroundColor: .systemBlue,
                           accessoryType: .disclosureIndicator)
           ]),
           
           // 第四组
           SettingsSection(title: nil, items: [
               SettingsItem(title: "钱包与 Apple Pay",
                           icon: UIImage(systemName: "creditcard"),
                           iconBackgroundColor: .black,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "Game Center",
                           icon: UIImage(systemName: "gamecontroller"),
                           iconBackgroundColor: .systemGreen,
                           accessoryType: .disclosureIndicator),
               SettingsItem(title: "iCloud",
                           icon: UIImage(systemName: "icloud"),
                           iconBackgroundColor: .systemBlue,
                           accessoryType: .disclosureIndicator)
           ])
       ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 如果是代码创建的 TableView
        // tableView = UITableView(frame: view.bounds, style: .grouped) -- 全新的 TableView
        self.title = "首页"
        // 设置背景色
        tableView.backgroundColor = UIColor.systemGroupedBackground
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }
}

extension EntriesViewController {
    
    // 返回分组数量
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // 返回每个分组的行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    // 配置每个 cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        let item = sections[indexPath.section].items[indexPath.row]
        
        // 使用 UIListContentConfiguration
        var configuration = UIListContentConfiguration.cell()
        configuration.text = item.title
        configuration.textProperties.font = UIFont.systemFont(ofSize: 17)
        
        // 设置图标
        // 创建带背景色的图标
       if let icon = item.icon, let bgColor = item.iconBackgroundColor {
           let iconWithBackground = createIconWithBackground(
               icon: icon,
               backgroundColor: bgColor,
               size: CGSize(width: 32, height: 28)
           )
           configuration.image = iconWithBackground
       }
        
        cell.contentConfiguration = configuration
        cell.accessoryType = item.accessoryType
        
        return cell
    }
    
    // 创建带背景色的图标
    func createIconWithBackground(icon: UIImage, backgroundColor: UIColor, size: CGSize) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { context in
                // 绘制圆角背景
                backgroundColor.setFill()
                let rect = CGRect(origin: .zero, size: size)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: 6)
                path.fill()
                
                // 绘制图标
                let iconSize = CGSize(width: size.width * 0.6, height: size.height * 0.6)
                let iconRect = CGRect(
                    x: (size.width - iconSize.width) / 2,
                    y: (size.height - iconSize.height) / 2,
                    width: iconSize.width,
                    height: iconSize.height
                )
                
                icon.withTintColor(.white).draw(in: iconRect)
            }
        }
    
    // 设置分组标题（如果需要）
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

}

extension EntriesViewController {
    // 处理点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sections[indexPath.section].items[indexPath.row]
        if(item.title == "Home"){
            toHomePage()
        } else if(item.title == "Combine"){
            toCombinePage()
        } else if(item.title == "Auto"){
            toAutoPage()
        } else if(item.title == "Feature"){
            toFeaturePage()
        } else if(item.title == "Feature2"){
            toFeaturePage2()
        } else {
            print("点击了：\(item.title)")
            showToast(message: item.title)
        }
        // 这里可以进行页面跳转
        // performSegue(withIdentifier: "ShowDetail", sender: item)
    }
    
    func toFeaturePage2(){
        let featureVC = NextFeatureController()
        navigationController?.pushViewController(featureVC, animated: true)
    }
    
    func toFeaturePage(){
        let featureVC = FeatureController()
        navigationController?.pushViewController(featureVC, animated: true)
    }
    
    func toAutoPage(){
        let autoVC = TestAutoController()
        navigationController?.pushViewController(autoVC, animated: true)
    }
    
    func toCombinePage(){
        let combineVC = CombineController()
        navigationController?.pushViewController(combineVC, animated: true)
    }
    
    func toHomePage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "helloHome")
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        // 自动消失
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true)
        }
    }
}

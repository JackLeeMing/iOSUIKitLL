//
//  TableViewController.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/6.
//
import UIKit

class TableViewController: UITableViewController  {
    var data = ["苹果", "香蕉", "橙子", "葡萄", "草莓", "西瓜", "桃子", "梨", "樱桃", "芒果"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "水果列表"
        tableView.backgroundColor = UIColor.systemBackground
    }
}

extension TableViewController {
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var configuration = UIListContentConfiguration.subtitleCell()
        configuration.text = data[indexPath.row]
        configuration.secondaryText = data[indexPath.row]
        configuration.image = UIImage(systemName: "apple.logo")
        // 自定义文本样式
        configuration.textProperties.font = UIFont.boldSystemFont(ofSize: 16)
        configuration.textProperties.color = UIColor.label
        
        configuration.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14)
        configuration.secondaryTextProperties.color = UIColor.secondaryLabel
        
        // 应用配置到 cell
        cell.contentConfiguration = configuration
        return cell
    }
}

extension TableViewController {
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectItem = data[indexPath.row]
        let alert = UIAlertController(title: "选中了", message: "你选择了：\(selectItem)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    // 处理删除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 更新 Model
            data.remove(at: indexPath.row)
            // 更新 View
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

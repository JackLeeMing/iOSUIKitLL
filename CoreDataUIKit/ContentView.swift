//
//  ContentView.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/3.
//
import SwiftUI

struct ContentView: View {
    let onDismiss: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    var body: some View {
            VStack {
                Text("这是 SwiftUI 视图")
                Button("点击我") {
                    // SwiftUI 逻辑
                    print("点击了")
                    dismiss()
                    onDismiss?()
                }
            }
    }
}


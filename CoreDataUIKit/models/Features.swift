//
//  Features.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/17.
//
struct Res: Codable {
    let code: String
    let message: String
    let data: ResData
}

struct ResData: Codable {
    let total: Int
    let page: Int
    let page_size: Int
    let data: [Feature]
}

struct Feature: Codable {
    let id: Int
    let imageUrl: String
    let title: String
    let tags: [String]
    let hotRate: Int
    let desc: String
    let funcId: String
    let order: Int
    let isOpen: Bool
}

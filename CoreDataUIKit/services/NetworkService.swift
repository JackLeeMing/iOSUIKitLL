//
//  NetworkService.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/17.
//
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    private init(){}
    
    func fetchFeatures() async -> [Feature] {
        return await withCheckedContinuation { continuation in
            AF.request("https://sua.h5lego.cn/api/v1/features?page=1&page_size=10")
                .validate()
                .responseDecodable(of: Res.self) { response in
                    switch response.result {
                    case .success(let res):
                        if(res.code == "0"){
                            continuation.resume(returning: res.data.data)
                        } else {
                            continuation.resume(returning: [])
                        }
                    case .failure(_):
                        continuation.resume(returning: [])
                    }
                }
        }

    }
}

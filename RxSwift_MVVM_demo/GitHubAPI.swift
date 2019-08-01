//
//  GitHubAPI.swift
//  RxSwift_MVVM_demo
//
//  Created by obor-5 on 2019/8/1.
//  Copyright © 2019 obor-5. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper

//初始化GitHub请求的provider
let GitHubProvider = MoyaProvider<GitHubAPI>()


/// 下面定义GitHub请求的endpoints（供provider使用）
///
/// 请求分类
public enum GitHubAPI{
    case resposotories(String)
}

//请求配置
extension GitHubAPI:TargetType {
    //服务器地址
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    //请求的具体路径
    public var path: String {
        switch self {
        case .resposotories:
            return "/search/repositories"
        }
    }
    
    //请求类别
    public var method: Moya.Method {
        return .get
    }
    
    //这个是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求任务事件-----这里带上参数
    public var task: Task {
        print("发起请求！")
        switch self {
        case .resposotories(let query):
            var params:[String:Any] = [:]
            params["q"] = query
            params["sort"] = "stars"
            params["order"] = "desc"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    //请求头
    public var headers: [String : String]? {
        return nil
    }
    
    
}

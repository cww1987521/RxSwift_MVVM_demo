//
//  GitHubModel.swift
//  RxSwift_MVVM_demo
//
//  Created by obor-5 on 2019/8/1.
//  Copyright © 2019 obor-5. All rights reserved.
//

import Foundation
import ObjectMapper

//包含查询所返回的所有仓库模型
struct  GitHubRepositories: Mappable{
    var totalCount : Int!
    var incompletResults: Bool!
    var items : [GitHubRepository]!//本次查询返回的所有仓库集合
    
    init() {
        print("init()")
        totalCount = 0
        incompletResults = false
        items = []
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        totalCount <- map["total_count"]
        incompletResults <- map["incomplet_results"]
        items <- map["items"]
    }
}

//单个仓库模型
struct GitHubRepository: Mappable {
    var id : Int!
    var name : String!
    var fullName : String!
    var htmlUrl : String!
    var description : String!
    
    
    init?(map: Map) {
        
    }
    
    //重写mappable的转化func
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        htmlUrl <- map["html_url"]
        description <- map["description"]
    }
}

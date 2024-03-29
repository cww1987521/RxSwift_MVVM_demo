//
//  GitHubViewModel.swift
//  RxSwift_MVVM_demo
//
//  Created by obor-5 on 2019/8/1.
//  Copyright © 2019 obor-5. All rights reserved.
//
/** 我们创建一个 ViewModel，它的作用就是将用户各种输入行为，转换成输出状态。本样例中，不管输入还是输出都是 Observable 类型。*/

import Foundation
import RxSwift
import Result
import RxCocoa

class GitHubViewModel {
    /****** 输入部分 *****/
    //查询行为
    fileprivate let searchAction:Driver<String>
    
    /****** 输出部分 ******/
    //查询结果
    let searcheResult: Driver<GitHubRepositories>
    //查询结果中的list
    let repositories: Driver<[GitHubRepository]>
    
    //清空结果的action
    let cleanResult: Driver<Void>
    
    //导航栏标题
    let navigationTitle: Driver<String>
    
    //viewModel初始化（根据输入实现对应的输出）
    init(searchAction:Driver<String>) {
        self.searchAction = searchAction
        
        //生成查询结果序列
        self.searcheResult = searchAction
            .filter{!$0.isEmpty}//过滤输入为空的查询action
            .flatMapLatest{str in
                GitHubProvider.rx.request(.resposotories(str))
                .filterSuccessfulStatusCodes()
                .mapObject(GitHubRepositories.self)
                .asDriver(onErrorDriveWith: Driver.empty())
                
        }
        
        //生成清空结果动作的序列，是个空序列
        self.cleanResult = searchAction
            .filter{$0.isEmpty}
            .map{_ in
                Void()
        }
        
        //生成查询结果里的资源列表序列（如果查询到结果则返回结果，如果是清空数据则返回空数组）
        self.repositories = Driver.merge(
            searcheResult.map{$0.items},
            cleanResult.map{[]}
        )
        
        //生成导航栏标题序列（如果查询到结果则返回数量，如果是清空数据则返回默认标题）
        self.navigationTitle = Driver.merge(
            searcheResult.map{"共有\($0.totalCount!)个结果"},
            cleanResult.map{"搜索"}
        )
    }
    
}

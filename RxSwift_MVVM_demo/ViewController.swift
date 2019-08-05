//
//  ViewController.swift
//  RxSwift_MVVM_demo
//
//  Created by obor-5 on 2019/8/1.
//  Copyright © 2019 obor-5. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    
    var tableView : UITableView!
    
    var searchBar : UISearchBar!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //创建tableView
        self.tableView = UITableView(frame: CGRect(x: 0, y: 88, width: self.view.frame.width, height: self.view.frame.height-88), style: .plain)
        //注册单元格
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 56))
        self.tableView.tableHeaderView = self.searchBar
        
        let searchAction = searchBar.rx.text.orEmpty.asDriver()
            .throttle(0.5)
            .distinctUntilChanged()
        
        
        //初始化viewModel
        let viewModel = GitHubViewModel(searchAction: searchAction)
        
        //viewModel中的navigationTitle绑定到导航栏title属性
        viewModel.navigationTitle.drive(self.navigationItem.rx.title).disposed(by: disposeBag)
        //viewModel中的repositories仓库数组绑定到tableView的items属性
        viewModel.repositories.drive(tableView.rx.items){ (tv, row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.htmlUrl
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GitHubRepository.self)
            .subscribe(onNext: { [weak self] item in
                self?.showAlert(title: item.fullName, message: item.description)
            }).disposed(by: disposeBag)
    }

    //显示alert消息
    func showAlert(title:String, message:String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }

}


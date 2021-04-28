//
//  MainView.swift
//  xChange
//
//  Created by Alessio on 2021-04-27.
//

import UIKit

final class MainView: BaseView {

    let tableView = UITableView()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(tableView)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(XChangeTableViewCell.self, forCellReuseIdentifier: XChangeTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//
//  FavoritesView.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

final class FavoritesView: BaseView {

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

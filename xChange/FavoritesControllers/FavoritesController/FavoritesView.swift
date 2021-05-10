//
//  FavoritesView.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

final class FavoritesView: BaseView {

    let emptyContentView = ContentPlaceholderView(title: nil,
                                                  image: nil)
    let tableView = UITableView()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(tableView,
                   emptyContentView)
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(XChangeTableViewCell.self, forCellReuseIdentifier: XChangeTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondaryTintColor
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyContentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
    func setupContent(for hasContent: Bool) {
        if hasContent {
            tableView.isHidden = false
            emptyContentView.isHidden = true
        } else {
            tableView.isHidden = true
            emptyContentView.isHidden = false
        }
    }
    
    func setup(with viewModel: FavoritesViewModel) {
        emptyContentView.title.text = viewModel.contentPlaceholderTitle
        emptyContentView.imageView.image = viewModel.contentPlaceholderImage
    }
}

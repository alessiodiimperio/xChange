//
//  ChatView.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

final class ChatView: BaseView {

    let tableView = UITableView()
    let emptyContentView = ContentPlaceholderView(title: nil,
                                                  image: nil)
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(tableView,
                    emptyContentView)
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .mainBackgroundColor
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        emptyContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupContent(for hasChats: Bool) {
        if hasChats {
            tableView.isHidden = false
            emptyContentView.isHidden = true
        } else {
            emptyContentView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func setup(with viewModel: ChatViewModel) {
        emptyContentView.title.text = viewModel.contentPlaceholderTitle
        emptyContentView.imageView.image = viewModel.contentPlaceholderImage
    }
}


//
//  ChatView.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

final class ChatView: BaseView {

    let tableView = UITableView()
    let emptyLabel = UILabel()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(tableView,
                    emptyLabel)
        
        setupTableView()
    }
    
    override func setupStyling() {
        super.setupStyling()
        
        emptyLabel.text = "This is where you will find your chats about Xchanges"
        emptyLabel.setupUI(font: .regularText, adjustsFontSizeToFitWidth: true)
    }
    
    private func setupTableView() {
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.lessThanOrEqualToSuperview().inset(.mediumMargin).priority(.low)
            make.top.equalToSuperview().offset(.giganticMargin)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupContent(for hasChats: Bool) {
        if hasChats {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        } else {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        }
    }
}


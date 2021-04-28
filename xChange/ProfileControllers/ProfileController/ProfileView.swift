//
//  ProfileView.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

final class ProfileView: BaseView {

    let tableView = UITableView()
    let emptyLabel = UILabel()
    let userNameLabel = UILabel()
    let emailLabel = UILabel()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(userNameLabel,
                    emailLabel,
                    tableView,
                    emptyLabel)
        
        setupTableView()
    }
    
    override func setupStyling() {
        super.setupStyling()
        
        emptyLabel.text = "No content..."
        emailLabel.setupUI(font: .boldBigTitle)
        userNameLabel.setupUI(font: .semiboldSubtitle)
    }
    
    private func setupTableView() {
        tableView.register(XChangeTableViewCell.self, forCellReuseIdentifier: XChangeTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        emailLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(.hugeMargin)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(.smallMargin)
            make.left.equalToSuperview().offset(.hugeMargin)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(.hugeMargin)
            make.bottom.left.right.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(.giganticMargin)
            make.centerX.equalToSuperview()
        }
    }
    
    func showEmptyView() {
        tableView.isHidden = true
        emptyLabel.isHidden = false
    }
    
    func showTableView() {
        tableView.isHidden = false
        emptyLabel.isHidden = true
    }
}

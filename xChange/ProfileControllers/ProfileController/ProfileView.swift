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
    let separator = UIView()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(userNameLabel,
                    emailLabel,
                    tableView,
                    emptyLabel,
                    separator)
        
        setupTableView()
    }
    
    override func setupStyling() {
        super.setupStyling()
        
        emptyLabel.text = "This is where will be able to view/edit your listings."
        emptyLabel.setupUI(font: .regularText, adjustsFontSizeToFitWidth: true)
        emailLabel.setupUI(font: .boldBigTitle)
        userNameLabel.setupUI(font: .semiboldSubtitle)
        separator.backgroundColor = .black
    }
    
    private func setupTableView() {
        tableView.register(XChangeTableViewCell.self, forCellReuseIdentifier: XChangeTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        emailLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().offset(.hugeMargin)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(.smallMargin)
            make.left.equalToSuperview().offset(.hugeMargin)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(.mediumMargin)
            make.height.equalTo(.point)
            make.top.equalTo(userNameLabel.snp.bottom).offset(.hugeMargin)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(.giganticMargin)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupContent(for hasXchanges: Bool) {
        if hasXchanges {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        } else {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        }
    }
    
    func hideUserLabels() {
        userNameLabel.isHidden = true
        emailLabel.isHidden = true
    }
    
    func showUserLabels() {
        userNameLabel.isHidden = false
        emailLabel.isHidden = false
    }
}

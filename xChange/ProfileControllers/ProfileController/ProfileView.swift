//
//  ProfileView.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

final class ProfileView: BaseView {

    let tableView = UITableView()
    let emptyContentView = ContentPlaceholderView(title: nil,
                                                  image: nil)
    let userNameLabel = UILabel()
    let emailLabel = UILabel()
    let separator = UIView()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(userNameLabel,
                    emailLabel,
                    tableView,
                    emptyContentView,
                    separator)
        
        setupTableView()
    }
    
    override func setupStyling() {
        super.setupStyling()
        
        emailLabel.setupUI(font: .boldBigTitle, adjustsFontSizeToFitWidth: true)
        userNameLabel.setupUI(font: .semiboldSubtitle, adjustsFontSizeToFitWidth: true)
        separator.backgroundColor = .mainBorderColor
        tableView.backgroundColor = .mainBackgroundColor
    }
    
    private func setupTableView() {
        tableView.register(XChangeTableViewCell.self, forCellReuseIdentifier: XChangeTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        emailLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(.hugeMargin)
            make.right.equalToSuperview().offset(.mediumMargin)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(.smallMargin)
            make.left.equalToSuperview().offset(.hugeMargin)
            make.right.equalToSuperview().offset(.mediumMargin)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(.hugeMargin)
            make.left.right.equalToSuperview().inset(.mediumMargin)
            make.height.equalTo(.point)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        emptyContentView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.bottom.left.right.equalToSuperview()
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
    
    func hideUserLabels() {
        userNameLabel.isHidden = true
        emailLabel.isHidden = true
    }
    
    func showUserLabels() {
        userNameLabel.isHidden = false
        emailLabel.isHidden = false
    }
    
    func setup(with viewModel: ProfileViewModel) {
        emptyContentView.title.text = viewModel.contentPlaceholderTitle
        emptyContentView.imageView.image = viewModel.contentPlaceholderImage
    }
}

//
//  FavoritesView.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

final class FavoritesView: BaseView {

    let emptyLabel = UILabel()
    let tableView = UITableView()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(tableView,
                   emptyLabel)
        
        setupTableView()
    }
    
    override func setupStyling() {
        super.setupStyling()
        emptyLabel.text = "This is where you can view your saved listings."
        emptyLabel.setupUI(font: .regularText, adjustsFontSizeToFitWidth: true)
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
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.lessThanOrEqualToSuperview().inset(.mediumMargin).priority(.low)
            make.top.equalToSuperview().offset(.giganticMargin)
        }
    }
    
    func setupContent(for hasContent: Bool) {
        if hasContent {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        } else {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        }
    }
}

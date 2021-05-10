//
//  BaseTableViewCell.swift
//  xChange
//
//  Created by Alessio on 2021-04-27.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
 
    let separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutMargins = .zero
        setup()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(separator)
    }
    
    func setupStyling() {
        separator.backgroundColor = .primaryTintColor
    }
    
    func setupConstraints() {
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(.mediumMargin)
            make.bottom.equalToSuperview()
            make.height.equalTo(.point)
        }
    }
}

extension BaseTableViewCell {
    func setup() {
        addSubviews()
        setupStyling()
        setupConstraints()
    }
}

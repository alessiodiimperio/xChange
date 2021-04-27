//
//  FieldLabel.swift
//  xChange
//
//  Created by Alessio on 2021-04-27.
//

import UIKit

final class FieldLabel: BaseView {
    
    let titleLabel = UILabel()
    let textLabel = UILabel()
    
    init(title: String? = nil, text: String? = nil) {
        self.titleLabel.text = title
        self.textLabel.text = text
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(titleLabel,
                    textLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(.mediumMargin)
        }
    }
}

//
//  FieldTextView.swift
//  xChange
//
//  Created by Alessio on 2021-04-27.
//

import UIKit

class FieldTextView: BaseView {

    let titleLabel = UILabel()
    let textView = UITextView()
    
    init(title: String? = nil, description: String? = nil) {
        super.init()
        titleLabel.text = title
        textView.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(titleLabel,
                    textView)
    }

    override func setupStyling() {
        super.setupStyling()
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        
        titleLabel.setupUI(font: .semiboldText)
        textView.font = .regularText
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(.smallMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

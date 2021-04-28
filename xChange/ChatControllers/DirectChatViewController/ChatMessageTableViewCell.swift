//
//  ChatTableViewCell.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

class ChatMessageTableViewCell: BaseTableViewCell {
    static let reuseIdentifier = "ChatMessageCell"
    
    let dateLabel = UILabel()
    let userMessageLabel = UILabel()
    let peerMessageLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(dateLabel,
                    userMessageLabel,
                    peerMessageLabel)
    }
    
    override func setupStyling() {
        super.setupStyling()
        userMessageLabel.backgroundColor = .green
        peerMessageLabel.backgroundColor = .blue
        userMessageLabel.setupUI(textColor: .white, font: .regularSubtext, textAlignment: .left)
        peerMessageLabel.setupUI(textColor: .white, font: .regularSubtext, textAlignment: .right)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(.smallMargin)
        }
        
        userMessageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(.mediumMargin)
            make.top.equalTo(dateLabel.snp.bottom).offset(.tinyMargin)
            make.bottom.equalToSuperview().inset(.smallMargin)
        }
        
        peerMessageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(.mediumMargin)
            make.top.equalTo(dateLabel.snp.bottom).offset(.tinyMargin)
            make.bottom.equalToSuperview().inset(.smallMargin)
        }
        
    }
    
    func setup(with viewModel: ChatMessageViewModel) {
        dateLabel.text = viewModel.date
        userMessageLabel.text = viewModel.userMessage
        peerMessageLabel.text = viewModel.peerMessage
    }
}

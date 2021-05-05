//
//  ChatTableViewCell.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

class ChatMessageTableViewCell: BaseTableViewCell {

    let buyerDateLabel = UILabel()
    let sellerDateLabel = UILabel()
    let buyerChatBubble = UIView()
    let sellerChatBubble = UIView()
    let buyerMessageLabel = UILabel()
    let sellerMessageLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews(buyerDateLabel,
                    sellerDateLabel,
                    buyerChatBubble,
                    sellerChatBubble)
        
        buyerChatBubble.addSubview(buyerMessageLabel)
        sellerChatBubble.addSubview(sellerMessageLabel)
    }
    
    override func setupStyling() {
        super.setupStyling()
        
        separator.isHidden = true
        
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        buyerMessageLabel.numberOfLines = 0
        buyerChatBubble.layer.cornerRadius = 10
        buyerChatBubble.backgroundColor = .systemGreen
        buyerChatBubble.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        sellerMessageLabel.numberOfLines = 0
        sellerChatBubble.layer.cornerRadius = 10
        sellerChatBubble.backgroundColor = .systemBlue
        sellerChatBubble.transform = CGAffineTransform(scaleX: 1, y: -1)

        
        buyerDateLabel.setupUI(font: .semiboldSubtext)
        buyerDateLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
        sellerDateLabel.setupUI(font: .semiboldSubtext)
        sellerDateLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        buyerMessageLabel.setupUI(textColor: .white, font: .semiboldText, textAlignment: .left)
        sellerMessageLabel.setupUI(textColor: .white, font: .semiboldText, textAlignment: .left)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        buyerDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(.smallMargin)
            make.right.equalTo(buyerChatBubble.snp.right)
        }
        
        sellerDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(.smallMargin)
            make.right.equalTo(sellerChatBubble.snp.right)
        }
        
        buyerChatBubble.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(.mediumMargin)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
            make.width.greaterThanOrEqualTo(buyerDateLabel.snp.width)
            make.bottom.equalTo(buyerDateLabel.snp.top).offset(-LayoutMargin.tinyMargin.rawValue)
            make.top.equalToSuperview().inset(.smallMargin)
        }
        
        buyerMessageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(.mediumMargin)
        }
        
        sellerChatBubble.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(.mediumMargin)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
            make.width.greaterThanOrEqualTo(sellerDateLabel.snp.width)
            make.bottom.equalTo(buyerDateLabel.snp.top).offset(-LayoutMargin.tinyMargin.rawValue)
            make.top.equalToSuperview().inset(.smallMargin)
        }
        
        sellerMessageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(.mediumMargin)
        }
    }
    
    func setup(with viewModel: ChatMessageViewModel) {
        buyerDateLabel.text = viewModel.date
        sellerDateLabel.text = viewModel.date
        
        if viewModel.isBuyer {
            sellerChatBubble.isHidden = true
            sellerDateLabel.isHidden = true
            buyerChatBubble.isHidden = false
            buyerDateLabel.isHidden = false
            buyerMessageLabel.text = viewModel.message
        } else {
            buyerChatBubble.isHidden = true
            buyerDateLabel.isHidden = true
            sellerDateLabel.isHidden = false
            sellerChatBubble.isHidden = false
            sellerMessageLabel.text = viewModel.message
        }
    }
}

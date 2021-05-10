//
//  DirectChatView.swift
//  xChange
//
//  Created by Alessio on 2021-05-03.
//

import UIKit

final class DirectChatView: BaseView {
    
    let tableView = UITableView()
    let inputContainer = UIView()
    
    let scrollView = UIScrollView()
    let messageInputTextView = UITextView()
    let sendButton = UIButton()
    let placeholderLabel = UILabel()
    
    override func addSubviews() {
        super.addSubviews()
        
        tableView.register(ChatMessageTableViewCell.self,
                           forCellReuseIdentifier: ChatMessageTableViewCell.reuseIdentifier)
        
        addSubviews(tableView,
                    inputContainer)
        
        inputContainer.addSubviews(messageInputTextView, sendButton)
        messageInputTextView.addSubviews(placeholderLabel)
        
    }
    
    override func setupStyling() {
            
        tableView.backgroundColor = .mainBackgroundColor
        
        inputContainer.withBorders(for: .top, width: LayoutMargin.point.rawValue, color: .lightGray)
        
        placeholderLabel.setupUI(textColor: .lightGray, font: .regularText)
        
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        messageInputTextView.font = .regularText
        
        sendButton.backgroundColor = .mainClickableTintColor
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        inputContainer.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        messageInputTextView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(sendButton.snp.left)
        }
            
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(inputContainer.snp.top)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(.smallMargin)
        }
    }
    
    func setup(with viewModel: DirectChatViewModel) {
        placeholderLabel.text = viewModel.messageInputPlaceholderText
        sendButton.setTitle(viewModel.sendButtonTitle, for: .normal)
    }
}

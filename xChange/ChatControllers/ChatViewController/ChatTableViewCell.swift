//
//  ChatTableViewCell.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

class ChatTableViewCell: XChangeTableViewCell {
    
    let unavailableView = UIView()
    let unavailableLabel = UILabel()
    let unreadMessageLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(unavailableView,
                    unreadMessageLabel)
        
        unavailableView.addSubview(unavailableLabel)
    }
    
    override func setupStyling() {
        super.setupStyling()
        
        backgroundColor = .mainBackgroundColor
        
        unavailableView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        unavailableLabel.setupUI(textColor: .darkGray, font: .boldBigTitle)
        unavailableLabel.text = "Removed by seller"
        
        unreadMessageLabel.setupUI(textColor: .white ,font: .boldSubtitle, textAlignment: .center)
        unreadMessageLabel.backgroundColor = .systemRed
        unreadMessageLabel.layer.cornerRadius = 8
        unreadMessageLabel.text = "NEW"
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        unavailableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        unavailableLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        unreadMessageLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(50)
            make.bottom.right.equalToSuperview().inset(.mediumMargin)
        }
    }
    
    func setup(with viewModel: ChatSubjectViewModel) {
        unreadMessageLabel.isHidden = !viewModel.unread
        unavailableView.isHidden = viewModel.available
        dateLabel.textLabel.text = viewModel.date
        titleLabel.textLabel.text = viewModel.title
        priceLabel.textLabel.text = viewModel.price
        
        if let url = URL(string: viewModel.imageLink) {
            itemImageView.af.setImage(withURL: url)
            itemImageView.contentMode = .scaleAspectFill
        } else {
            itemImageView.contentMode = .scaleAspectFit
        }
    }
}


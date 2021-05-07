//
//  MainDetailView.swift
//  xChange
//
//  Created by Alessio on 2021-04-27.
//

import UIKit

class DetailView: BaseView {
    
    let dateLabel = FieldLabel(title: "Date:")
    let titleLabel = FieldLabel(title: "Titel:")
    let priceLabel = FieldLabel(title: "Pris:")
    let authorLabel = FieldLabel(title: "Author:")
    let descriptionTextView = FieldTextView(title: "Description:")
    let itemImageView = UIImageView()
    let favoriteButton = UIButton()
    let chatButton = UIButton()
    let soldButton = UIButton()
    

    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(dateLabel,
                    titleLabel,
                    priceLabel,
                    authorLabel,
                    descriptionTextView,
                    itemImageView,
                    favoriteButton,
                    chatButton,
                    soldButton)
    }
    
    override func setupStyling() {
        super.setupStyling()
        
        chatButton.setImage(UIImage(systemName: "message"), for: .normal)
        soldButton.setTitle("Sold", for: .normal)
        soldButton.backgroundColor = .systemBlue
        
        dateLabel.titleLabel.setupUI(font: .semiboldText, textAlignment: .right)
        authorLabel.titleLabel.setupUI(font: .semiboldText, textAlignment: .right)
        priceLabel.titleLabel.setupUI(font: .semiboldText, textAlignment: .right)

    }
    
    func setup(if isUsers: Bool) {
        if isUsers {
            chatButton.isHidden = true
            favoriteButton.isHidden = true
            soldButton.isHidden = false
        } else {
            chatButton.isHidden = false
            favoriteButton.isHidden = false
            soldButton.isHidden = true
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
            
        itemImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(.mediumMargin)
            make.right.equalToSuperview().inset(.mediumMargin)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(.mediumMargin)
            make.right.equalToSuperview().inset(.mediumMargin)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(.mediumMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(.mediumMargin)
            make.right.equalToSuperview().inset(.mediumMargin)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(.mediumMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        descriptionTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        chatButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(.mediumMargin)
            make.width.height.equalTo(LayoutConstants.minimumTappableSize)
            make.right.equalToSuperview().inset(.largeMargin)
            make.bottom.equalToSuperview().inset(.mediumMargin)
        }

        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(LayoutConstants.minimumTappableSize)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(chatButton)
        }
        
        soldButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(LayoutConstants.minimumTappableSize)
            make.left.right.bottom.equalToSuperview().inset(.largeMargin)
        }
    }   
}

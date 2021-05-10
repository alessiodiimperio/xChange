//
//  ChatTableViewCell.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

class ChatTableViewCell: BaseTableViewCell {
    
    let dateLabel = UILabel()
    let titleLabel = FieldLabel(title: "Title:", text: nil)
    let subjectImage = UIImageView()
    let priceLabel = UILabel()
    let unavailableView = UIView()
    let unavailableLabel = UILabel()
    let unreadMessageLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(dateLabel,
                    titleLabel,
                    subjectImage,
                    priceLabel,
                    unavailableView,
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
        
        subjectImage.image = subjectImage.placeHolderPhoto()
        subjectImage.tintColor = .primaryTintColor
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(.smallMargin)
        }
        
        subjectImage.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.height.width.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(subjectImage.snp.right).offset(.mediumMargin)
            make.right.equalToSuperview().inset(.mediumMargin)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(subjectImage.snp.right).offset(.largeMargin)
            make.bottom.equalToSuperview().inset(.mediumMargin)
        }
        
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
        dateLabel.text = viewModel.date
        titleLabel.textLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        if let url = URL(string: viewModel.imageLink) {
            subjectImage.af.setImage(withURL: url)
            subjectImage.contentMode = .scaleAspectFill
        } else {
            subjectImage.contentMode = .scaleAspectFit
        }
    }
}


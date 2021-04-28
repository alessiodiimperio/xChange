//
//  ChatTableViewCell.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

class ChatTableViewCell: BaseTableViewCell {
    static let reuseIdentifier = "ChatSubjetCell"
    
    let dateLabel = UILabel()
    let titleLabel = FieldLabel(title: "Title:", text: nil)
    let subjectImage = UIImageView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(dateLabel,
                    titleLabel,
                    subjectImage)
    }
    
    override func setupStyling() {
        super.setupStyling()

        subjectImage.image = subjectImage.placeHolderPhoto()
        
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
        
    }
    
    func setup(with viewModel: ChatSubjectViewModel) {
        dateLabel.text = viewModel.date
    }
}


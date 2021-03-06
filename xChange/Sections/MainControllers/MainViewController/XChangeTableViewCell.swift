//
//  XChangeProfileTableViewCell.swift
//  xChange
//
//  Created by Alessio on 2021-03-16.
//
import Alamofire
import AlamofireImage
import SnapKit
import UIKit

class XChangeTableViewCell: BaseTableViewCell {
    
    let dateLabel = FieldLabel(title: "Date:")
    let titleLabel = FieldLabel(title: "Titel:")
    let priceLabel = FieldLabel(title: "Price:")
    let itemImageView = UIImageView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(dateLabel,
                    titleLabel,
                    priceLabel,
                    itemImageView
                    )
    }
    
    override func setupStyling() {
        super.setupStyling()
        
        backgroundColor = .mainBackgroundColor
        
        itemImageView.clipsToBounds = true
        itemImageView.tintColor = .primaryTintColor
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        itemImageView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.top.left.equalToSuperview()
            make.bottom.equalTo(separator.snp.top)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(.smallMargin)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.top).offset(.xlargeMargin)
            make.left.equalTo(itemImageView.snp.right).offset(.mediumMargin)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(itemImageView.snp.right).offset(.mediumMargin)
            make.bottom.equalTo(itemImageView.snp.bottom).inset(.mediumMargin)
        }
    }
    
    func setup(with viewModel: XChangeCellViewModel) {
    
        if let url = viewModel.image {
            itemImageView.af.setImage(withURL: url)
            itemImageView.contentMode = .scaleAspectFill
        } else {
            itemImageView.image = UIImageView().placeHolderPhoto()
            itemImageView.contentMode = .scaleAspectFit
        }
        
        dateLabel.textLabel.text = viewModel.date
        titleLabel.textLabel.text = viewModel.title
        priceLabel.textLabel.text = viewModel.price
    }
}

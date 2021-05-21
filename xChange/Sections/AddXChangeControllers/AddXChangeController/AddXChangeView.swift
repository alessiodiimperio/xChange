//
//  AddXChangeView.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit


final class AddXChangeView: BaseView, ViewWithLoadingState {

    let imageView = UIImageView()
    let plusIcon = UIImageView()
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let createButton = UIButton()
    let priceTextField = UITextField()
    let placeholder = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 20))

    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(imageView,
                   plusIcon,
                   titleTextField,
                   descriptionTextView,
                   createButton,
                   priceTextField,
                   placeholder)
    }
    
    override func setupStyling() {
        super.setupStyling()
        addPlaceholderToDescriptionTextView()
        
        backgroundColor = .mainBackgroundColor
        
        imageView.image = imageView.placeHolderPhoto()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primaryTintColor
        
        plusIcon.image = UIImage(systemName: "plus.circle.fill")
        plusIcon.tintColor = .mainClickableTintColor
        
        titleTextField.withBorders(for: .bottom, color: .mainBorderColor)
        titleTextField.autocorrectionType = .no
        
        priceTextField.withBorders(for: .bottom, color: .mainBorderColor)
        priceTextField.autocorrectionType = .no
        

        createButton.backgroundColor = .mainClickableTintColor
        createButton.layer.cornerRadius = 10
        
        descriptionTextView.backgroundColor = .mainBackgroundColor
        descriptionTextView.font = .regularText
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.withBorders(for: [.all], color: .mainBorderColor)
        descriptionTextView.autocorrectionType = .no
    }
    
    private func addPlaceholderToDescriptionTextView(){
        placeholder.font = .systemFont(ofSize: 16)
        placeholder.textColor = .lightGray
        placeholder.isUserInteractionEnabled = false
        descriptionTextView.addSubview(placeholder)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.5)
            make.top.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        plusIcon.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.right).inset(.giganticMargin)
            make.centerY.equalTo(imageView.snp.bottom).inset(.giganticMargin)
            make.width.height.equalTo(60)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(.largeMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(.mediumMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(.mediumMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
            make.height.equalTo(200).priority(.low)
        }
        
        placeholder.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView).offset(.smallMargin)
            make.left.equalTo(descriptionTextView)
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(.mediumMargin)
            make.height.equalTo(LayoutConstants.minimumTappableSize)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(.largeMargin)
        }
    }
    
    func setup(with viewModel: AddXChangeViewModel) {
        titleTextField.placeholder = viewModel.titlePlaceholderText
        priceTextField.placeholder = viewModel.pricePlaceholderText
        placeholder.text = viewModel.descriptionsPlaceholderText
        createButton.setTitle(viewModel.createButtonTitle, for: .normal)
    }
}

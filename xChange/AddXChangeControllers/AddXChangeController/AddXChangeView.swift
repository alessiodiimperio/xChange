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
        
        
        
        imageView.image = imageView.placeHolderPhoto()
        imageView.contentMode = .scaleAspectFit
        
        plusIcon.image = UIImage(systemName: "plus.circle.fill")
        
        titleTextField.placeholder = "Title"
        titleTextField.withBorders(for: .bottom)
        
        priceTextField.placeholder = "Price"
        priceTextField.withBorders(for: .bottom)
        
        placeholder.text = "Description"

        createButton.setTitle("Create", for: .normal)
        createButton.backgroundColor = .systemBlue
        createButton.layer.cornerRadius = 20
        
        descriptionTextView.font = .regularText
        descriptionTextView.withBorders(for: [.all])
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
            make.centerX.equalTo(imageView.snp.right).inset(.largeMargin)
            make.centerY.equalTo(imageView.snp.bottom).inset(.largeMargin)
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
            make.height.equalTo(200)
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
        }
    }
}

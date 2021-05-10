//
//  SuccessView.swift
//  xChange
//
//  Created by Alessio on 2021-05-05.
//

import UIKit

final class SuccessView: UIView {
    
    let containerView = UIView()
    let subtitle = UILabel()
    let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setupStyling()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubviews(containerView)
        containerView.addSubviews(imageView, subtitle)
    }
    
    func setupStyling() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        imageView.tintColor = .primaryTintColor
        
        containerView.backgroundColor = .secondaryTintColor
        containerView.roundCorners(radius: 20)
        containerView.withBorders(for: .all, color: .mainBorderColor)
        
        subtitle.numberOfLines = 0
        subtitle.setupUI(font: .boldSubtitle)
    }
    
    func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(.hugeMargin)
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(.mediumMargin)
            make.width.height.equalTo(200)
        }
        
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(.largeMargin)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(.mediumMargin)
        }
    }
    
    func setSubtitle(_ text: String) {
        self.subtitle.text = text
    }
}

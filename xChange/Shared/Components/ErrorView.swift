//
//  ErrorView.swift
//  xChange
//
//  Created by Alessio on 2021-05-05.
//

import UIKit

final class ErrorView: UIView {
    let containerView = UIView()
    let subtitle = UILabel()
    let confirmButton = UIButton()
    let imageView = UIImageView(image: UIImage(systemName: "xmark"))
    
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
        containerView.addSubviews(imageView,
                                  subtitle,
                                  confirmButton)
        
    }
    
     func setupStyling() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        containerView.backgroundColor = .white
        containerView.withBorders(for: .all, color: .mainBorderColor)
        
        subtitle.numberOfLines = 0
        subtitle.setupUI(font: .boldSubtitle)
        
        confirmButton.setTitle("OK", for: .normal)
        confirmButton.backgroundColor = .systemRed
    }
    
     func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(.hugeMargin)
            make.height.width.equalTo(200)
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.right.equalToSuperview().inset(.largeMargin)
        }
        
        subtitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(.largeMargin)
            make.center.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(.largeMargin)
            make.height.equalTo(LayoutConstants.minimumTappableSize)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    func setSubtitle(_ text: String) {
        self.subtitle.text = text
    }
}

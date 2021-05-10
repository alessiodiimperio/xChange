//
//  ContentPlaceholderView.swift
//  xChange
//
//  Created by Alessio on 2021-05-08.
//

import UIKit

final class ContentPlaceholderView: BaseView {
 
    let title = UILabel()
    let imageView:UIImageView
    
    init(title: String?, image: UIImage?) {
        self.title.text = title
        self.imageView = UIImageView(image: image)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(imageView,
                    title)
    }
    
    override func setupStyling() {
        super.setupStyling()
        backgroundColor = .secondaryTintColor
        
        title.setupUI(font: .semiboldText, adjustsFontSizeToFitWidth: true)
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primaryTintColor
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
            make.left.right.lessThanOrEqualToSuperview().inset(.mediumMargin).priority(.low)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview().multipliedBy(0.5)
            make.center.equalToSuperview()
        }
    }
}

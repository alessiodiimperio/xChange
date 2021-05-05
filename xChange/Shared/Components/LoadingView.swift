//
//  LoadingView.swift
//  xChange
//
//  Created by Alessio on 2021-05-05.
//

import UIKit

final class LoadingView: UIView {
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let subtitle = UILabel()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setupStyling()
        setupConstraints()
        activityIndicator.color = .white
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubviews(activityIndicator,
                    subtitle)
    }
    
     func setupStyling() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        subtitle.numberOfLines = 1
        subtitle.setupUI(font: .boldSubtitle)
    }
    
    func setupConstraints() {
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subtitle.snp.makeConstraints { make in
            make.centerX.equalTo(activityIndicator)
            make.top.equalTo(activityIndicator.snp.bottom).offset(.giganticMargin)
        }
    }
    
    func setSubtitle(_ text: String) {
        self.subtitle.text = text
    }
}

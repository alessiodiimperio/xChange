//
//  BaseView.swift
//  xChange
//
//  Created by Alessio on 2021-04-27.
//

import UIKit

class BaseView: UIView {

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() { }
    
    func setupStyling() {
        backgroundColor = .white
    }
    
    func setupConstraints() { }

}

extension BaseView {
    func setup() {
        addSubviews()
        setupStyling()
        setupConstraints()
    }
}

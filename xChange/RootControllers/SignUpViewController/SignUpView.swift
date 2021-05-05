//
//  SignUpView.swift
//  xChange
//
//  Created by Alessio on 2021-04-30.
//

import UIKit

final class SignUpView: BaseView {
    
    
    let usernameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let createBtn = UIButton()
    let errorLabel = UILabel()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews(usernameTextField,
                    emailTextField,
                    passwordTextField,
                    createBtn,
                    errorLabel)
    }
    override func setupStyling() {
        super.setupStyling()
        usernameTextField.placeholder = "Username"
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        createBtn.setTitle("Create", for: .normal)
        createBtn.backgroundColor = .systemRed
        createBtn.setTitleColor(.white, for: .normal)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        usernameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(.mediumMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(.mediumMargin)
            make.bottom.equalTo(snp.centerY)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        createBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(.mediumMargin)
            make.width.equalTo(150)
            make.height.equalTo(LayoutConstants.minimumTappableSize)
            make.centerX.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(createBtn.snp.bottom).offset(.mediumMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
    }
}

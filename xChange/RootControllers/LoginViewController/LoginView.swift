//
//  LoginView.swift
//  xChange
//
//  Created by Alessio on 2021-04-30.
//

import UIKit
import SnapKit

final class LoginView: BaseView {
    
    let bannerImageView = UIImageView()
    let titleLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let errorLabel = UILabel()
    let signInBtn = UIButton()
    let signUpLabel = UILabel()
    let signUpBtn = UIButton()
    let forgotPasswordBtn = UIButton()
    let horizontalStackView = UIStackView()
    
    override func addSubviews() {
        super.addSubviews()
                
        addSubviews(bannerImageView,
                    titleLabel,
                    emailTextField,
                    passwordTextField,
                    errorLabel,
                    signInBtn,
                    horizontalStackView,
                    forgotPasswordBtn
                    )
        horizontalStackView.addSubviews(signUpLabel, signUpBtn)

    }
    
    override func setupStyling() {
        super.setupStyling()
        errorLabel.setupUI(textColor: .systemRed, font: .regularText)
        titleLabel.setupUI(font: .boldTitle)
        errorLabel.numberOfLines = 0
        
        titleLabel.text = "xChange"
        titleLabel.setupUI(font: .regularSuperBigTitle)
        
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        signInBtn.setTitle("Sign In", for: .normal)
        signInBtn.backgroundColor = .systemPink
        signInBtn.setTitleColor(.white, for: .normal)
        
        signUpLabel.text = "Don't have an account?"
        signUpLabel.setupUI(textColor: .black, font: .regularSubtitle)
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.setTitleColor(.systemRed, for: .normal)
        
        forgotPasswordBtn.setTitle("Forgot password", for: .normal)
        forgotPasswordBtn.setTitleColor(.systemRed, for: .normal)
        
        bannerImageView.image = UIImage(named: "banner")
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillProportionally
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        bannerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(.mediumMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(.mediumMargin)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(.largeMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(.mediumMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        signInBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(.giganticMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(signInBtn.snp.bottom).offset(.mediumMargin)
            make.left.right.equalToSuperview().inset(.largeMargin)
        }
        
        forgotPasswordBtn.snp.makeConstraints { make in
            make.top.equalTo(signInBtn.snp.bottom).offset(.giganticMargin)
            make.centerX.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(.mediumMargin)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        signUpBtn.snp.makeConstraints { make in
            make.left.equalTo(signUpLabel.snp.right).offset(.tinyMargin)
            make.top.right.bottom.equalToSuperview()
        }
    }
    
    func confirmPasswordResetSent() {
        errorLabel.text = "Password reset sent to email. Check your inbox!"
    }
}

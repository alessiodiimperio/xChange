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
        
        backgroundColor = .mainBackgroundColor
        
        errorLabel.setupUI(textColor: .systemRed, font: .regularText)
        titleLabel.setupUI(font: .boldTitle)
        errorLabel.numberOfLines = 0
        
        
        titleLabel.setupUI(font: .regularSuperBigTitle)
        
        emailTextField.autocorrectionType = .no
        
        passwordTextField.isSecureTextEntry = true
        
        signInBtn.backgroundColor = .mainClickableTintColor
        signInBtn.setTitleColor(.white, for: .normal)
        
        signUpLabel.setupUI(textColor: .black, font: .regularSubtitle)
        signUpBtn.backgroundColor = .mainClickableTintColor
        signUpBtn.setTitleColor(.secondaryTintColor, for: .normal)
        signUpBtn.layer.cornerRadius = 5
        
        forgotPasswordBtn.setTitleColor(.mainClickableTintColor, for: .normal)
        
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
            make.height.equalTo(LayoutConstants.minimumTappableSize)
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
            make.bottom.equalToSuperview().inset(.largeMargin)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        signUpBtn.snp.makeConstraints { make in
            make.left.equalTo(signUpLabel.snp.right).offset(.tinyMargin)
            make.width.equalTo(80)
            make.top.right.bottom.equalToSuperview()
        }
    }
    
    func confirmPasswordResetSent(_ errorMessage: String?) {
        errorLabel.text = errorMessage
    }
    
    func clearErrors() {
        errorLabel.text = nil
    }
    
    func setup(with viewModel: LoginViewModel) {
        titleLabel.text = viewModel.titleText
        emailTextField.placeholder = viewModel.emailPlaceholderText
        passwordTextField.placeholder = viewModel.passwordPlaceholderText
        signInBtn.setTitle(viewModel.signInButtonTitle, for: .normal)
        signUpLabel.text = viewModel.signUpLabelText
        signUpBtn.setTitle(viewModel.signUpButtonTitle, for: .normal)
        forgotPasswordBtn.setTitle(viewModel.forgotPasswordButtonTitle, for: .normal)
        bannerImageView.image = viewModel.bannerImage

        
    }
}

//
//  HasLoadingState.swift
//  xChange
//
//  Created by Alessio on 2021-05-05.
//

import Foundation
import RxSwift
import RxCocoa

enum LoadingState {
    case initial
    case loading
    case success(subtitle: String)
    case error(subtitle: String)
}

protocol ViewControllerWithLoadingState {
    var disposeBag: DisposeBag { get }
    func setupStates()
    func setupLoadingObservables()
    func getState() -> ViewModelWithLoadingState
    func getView() -> ViewWithLoadingState
    func loadingView() -> LoadingView
    func errorView() -> ErrorView
    func successView() -> SuccessView
}

extension ViewControllerWithLoadingState where Self: BaseViewController {

    func setupStates() {
        getView().setupStates()
        setupLoadingObservables()
    }
    
    func setupLoadingObservables() {
        getState().state.asDriver()
            .drive(onNext: { [weak self] state in
                self?.getView().handleStateChange(for: state)
                self?.setEditing(false, animated: true)
                })
            .disposed(by: disposeBag)
        
        getView().errorView.confirmButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.getState().setInitialState()
            })
            .disposed(by: disposeBag)
    }
}

protocol ViewWithLoadingState {
    var loadingView: LoadingView { get }
    var successView: SuccessView { get }
    var errorView: ErrorView { get }
    
    func setupStates()
    func handleStateChange(for state: LoadingState)
}

extension ViewWithLoadingState where Self: BaseView {
    
    func setupStates() {
        addSubviews(loadingView, successView, errorView)
        
        loadingView.isHidden = true
        successView.isHidden = true
        errorView.isHidden = true
        
        loadingView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        successView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        errorView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func handleStateChange(for state: LoadingState) {
        switch state {
        case .initial:
            handleDefaultState()
        case .loading:
            handleLoadingState()
        case .success(let successMessage):
            handleSuccessState(successMessage)
        case .error(let errorMessage):
            handleErrorState(errorMessage)
        }
    }
    
    private func handleDefaultState() {
        loadingView.isHidden = true
        successView.isHidden = true
        errorView.isHidden = true
    }
    
    private func handleLoadingState() {
        loadingView.isHidden = false
        successView.isHidden = true
        errorView.isHidden = true
    }
    
    private func handleSuccessState(_ successMessage: String) {
        loadingView.isHidden = true
        successView.isHidden = false
        errorView.isHidden = true
        successView.setSubtitle(successMessage)
    }
    
    private func handleErrorState(_ errorMessage: String) {
        loadingView.isHidden = true
        successView.isHidden = true
        errorView.isHidden = false
        errorView.setSubtitle(errorMessage)
    }
}

protocol ViewModelWithLoadingState {
    var state: BehaviorRelay<LoadingState> { get }
}

extension ViewModelWithLoadingState {
    
    func setInitialState() {
        state.accept(.initial)
    }
    
    func setLoadingState() {
        state.accept(.loading)
    }
    
    func setSuccessState(_ successMessage: String = "Success") {
        
        state.accept(.success(subtitle: successMessage))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + LayoutConstants.successPromptDuration) {
            self.state.accept(.initial)
        }
    }
    
    func setErrorState(_ errorMessage: String = "Error") {
        state.accept(.error(subtitle: errorMessage))
    }
}


//
//  AddxChangeController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol  AddXChangeViewControllerDelegate: class {
    func dismissViewController(_ viewController: UIViewController)
    func present(_ viewController: UIViewController, onNav: UINavigationController?, animated: Bool)
    func startCamera(imagePickerDelegate: AddXChangeController)
    func setSelectedImage(_ image: UIImage?, to: AddXChangeController)
}

class AddXChangeController: BaseViewController, ViewControllerWithLoadingState {

    weak var delegate: AddXChangeViewControllerDelegate!
    let contentView: AddXChangeView & ViewWithLoadingState
    var viewModel: AddXChangeViewModel & ViewModelWithLoadingState
    
    init(view: AddXChangeView, viewModel: AddXChangeViewModel, delegate: AddXChangeViewControllerDelegate?) {
        self.contentView = view
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStates()
    }
    
    override func setupObservables() {
        super.setupObservables()
        
        let imageViewTapped = contentView.imageView.rx.tapGesture()
            .when(.recognized)
            .map { _ -> Void in
                return
            }.asDriver(onErrorJustReturn: ())
        
        let output = viewModel.transform(AddXChangeViewModel.Input(
            titleTextfieldTrigger: contentView.titleTextField.rx.text.asDriver(),
            descriptionTextViewTrigger: contentView.descriptionTextView.rx.text.asDriver(),
            createButtonTrigger: contentView.createButton.rx.tap.asDriver(),
            imageViewTappedTrigger: imageViewTapped.asDriver(),
            priceTextFieldTrigger: contentView.priceTextField.rx.text.asDriver()
        ))
        
        output.onImageViewImage
            .drive(contentView.imageView.rx.image)
            .disposed(by: disposeBag)
            
        output.onTitleTextFieldText
            .drive(contentView.titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.onDescriptionTextViewText
            .drive(contentView.descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.onDescriptionPlaceholder
            .drive(contentView.placeholder.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.onCreateButtonTapped
            .drive(onNext: {[weak self] in
                self?.resetForm()
            }).disposed(by: disposeBag)
        
        output.onCreateButtonEnabled.map { enabled in
            enabled ? 1 : 0.4
        }.drive(onNext: {[weak self] alpha in
            self?.contentView.createButton.alpha = alpha
        })
        .disposed(by: disposeBag)
        
        output.onCreateButtonEnabled
            .drive(contentView.createButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.onImageViewTapped
            .drive(onNext: {[weak self] in
                self?.startCamera()
            })
            .disposed(by: disposeBag)
        
        output.onPlaceHolderUpdated
            .drive(contentView.plusIcon.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func resetForm(){
        contentView.imageView.image = contentView.imageView.placeHolderPhoto()
        contentView.titleTextField.text = nil
        contentView.priceTextField.text = nil
        contentView.descriptionTextView.text = nil
    }
    
    func getState() -> ViewModelWithLoadingState {
        viewModel
    }
    
    func getView() -> ViewWithLoadingState {
        contentView
    }
    
    func loadingView() -> LoadingView {
        contentView.loadingView
    }
    func errorView() -> ErrorView {
        contentView.errorView
    }
    func successView() -> SuccessView {
        contentView.successView
    }
}

extension AddXChangeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func startCamera(){
        delegate?.startCamera(imagePickerDelegate: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        delegate?.setSelectedImage(editedImage, to: self)
    }
}

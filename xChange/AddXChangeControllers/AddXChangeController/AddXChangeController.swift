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

class AddXChangeController: UIViewController {
    
    weak var delegate: AddXChangeViewControllerDelegate!
    var viewModel: AddXChangeViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var plusIcon: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    
    private(set) var placeholder: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlaceholderToDescriptionTextView()
        setupObservables()
    }
    
    private func addPlaceholderToDescriptionTextView(){
        placeholder = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 20))
        placeholder.font = .systemFont(ofSize: 14)
        placeholder.text = "Description"
        placeholder.textColor = .lightGray
        placeholder.isUserInteractionEnabled = false
        descriptionTextView.addSubview(placeholder)
    }
    
    private func setupObservables(){
        
        let imageViewTapped = imageView.rx.tapGesture()
            .when(.recognized)
            .map { _ -> Void in
                return
            }.asDriver(onErrorJustReturn: ())
        
        let output = viewModel.transform(AddXChangeViewModel.Input(
                                                                   titleTextfieldTrigger: titleTextField.rx.text.asDriver(),
                                                                   descriptionTextViewTrigger: descriptionTextView.rx.text.asDriver(),
                                                                   createButtonTrigger: createButton.rx.tap.asDriver(),
                                                                   imageViewTappedTrigger: imageViewTapped.asDriver(),
                                                                   priceTextFieldTrigger: priceTextField.rx.text.asDriver()
        ))
        
        output.onImageViewImage
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
            
        output.onTitleTextFieldText
            .drive(titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.onDescriptionTextViewText
            .drive(descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.onDescriptionPlaceholder
            .drive(placeholder.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.onCreateButtonTapped
            .drive(onNext: {[weak self] in
//                self?.resetForm()
            }).disposed(by: disposeBag)
        
        output.onCreateButtonEnabled
            .drive(createButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.onImageViewTapped
            .drive(onNext: {[weak self] in
                self?.startCamera()
            })
            .disposed(by: disposeBag)
        
        output.onPlaceHolderUpdated
            .drive(plusIcon.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func resetForm(){
        imageView.image = imageView.placeHolderPhoto()
        titleTextField.text = nil
        priceTextField.text = nil
        descriptionTextView.text = nil        
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

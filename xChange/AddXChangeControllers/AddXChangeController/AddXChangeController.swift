//
//  AddxChangeController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit
import RxSwift
import RxCocoa

class AddXChangeController: UIViewController {
    var viewModel:AddXChangeViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createButton: UIButton!
    
    var placeholder: UILabel!
    
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
        
        let output = viewModel.transform(AddXChangeViewModel.Input(titleTextfieldTrigger: titleTextField.rx.text.asDriver(),
                                                                   descriptionTextViewTrigger: descriptionTextView.rx.text.asDriver(),
                                                                   createButtonTrigger: createButton.rx.tap.asDriver())
        )
        
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
            .drive().disposed(by: disposeBag)
        
        output.onCreateButtonEnabled
            .drive(createButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

//
//  DirectChatViewController.swift
//  xChange
//
//  Created by Alessio on 2021-05-03.
//

import UIKit

class DirectChatViewController: BaseViewController {

    let contentView: DirectChatView
    let viewModel: DirectChatViewModel
    
    init(view: DirectChatView, viewModel: DirectChatViewModel) {
        self.contentView = view
        self.viewModel = viewModel
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.subScribeToChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.unSubscribeToChat()
    }
    
    override func setupObservables() {
        super.setupObservables()
        
        let output = viewModel.transform(DirectChatViewModel.Input(sendButtonTrigger: contentView.sendButton.rx.tap.asDriver(),
                                                                   textInputTrigger: contentView.messageInputTextView.rx.text.asDriver()))
        
        output.onTextInput
            .drive(contentView.messageInputTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.onTextInput
            .map { textInput -> Bool in
                guard let textInput = textInput else { return false }
                return !textInput.isEmpty
            }
            .drive(contentView.placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
            
        
        output.onSendButtonTapped
            .drive(onNext: { [weak self] in
                self?.contentView.messageInputTextView.text = nil
            })
            .disposed(by: disposeBag)
        
        output.onMessages
            .drive(contentView.tableView.rx.items(cellIdentifier: ChatMessageTableViewCell.reuseIdentifier)) { [weak self] _, message, cell in
    
                guard let cell = cell as? ChatMessageTableViewCell else { return }
                cell.setup(with: ChatMessageViewModel(from: message, self?.viewModel.currentUserId))
                
            }.disposed(by: disposeBag)
    }
}

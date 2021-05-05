//
//  ChatViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import RxCocoa
import RxSwift
import UIKit

protocol ChatViewControllerDelegate: AnyObject {
    func didSelectGoToDirectChat(with chatId: String)
}

class ChatViewController: BaseViewController {
    
    weak var delegate: ChatViewControllerDelegate?
    let contentView: ChatView
    var viewModel:ChatViewModel
    
    init(view: ChatView, viewModel: ChatViewModel, delegate: ChatViewControllerDelegate?) {
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
    }
    
    override func setupObservables() {
        super.setupObservables()
        let output = viewModel.transform(ChatViewModel.Input(itemSelectedTrigger: contentView.tableView.rx.itemSelected.asDriver()))
        
        output.onChats
            .drive(contentView.tableView.rx.items(cellIdentifier: ChatTableViewCell.reuseIdentifier)) { _, chat, cell in
                
                guard let cell = cell as? ChatTableViewCell else { return }
                cell.setup(with: ChatSubjectViewModel(from: chat))

            }.disposed(by: disposeBag)
        
        output.onItemSelected
            .drive (onNext:{ [weak self] chatId in
                guard let chatId = chatId else { return }
                self?.delegate?.didSelectGoToDirectChat(with: chatId)
            })
            .disposed(by: disposeBag)

    }
}

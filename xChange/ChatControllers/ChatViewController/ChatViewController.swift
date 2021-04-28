//
//  ChatViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import RxCocoa
import RxSwift
import UIKit

class ChatViewController: BaseViewController {
    
    let contentView = ChatView()
    var viewModel:ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
    }
    
    private func setupObservables() {
        let output = viewModel.transform(ChatViewModel.Input())
        
        output.chats
            .drive(contentView.tableView.rx.items(cellIdentifier: ChatTableViewCell.reuseIdentifier)) { _, chat, cell in
                
                guard let cell = cell as? ChatTableViewCell else { return }
                cell.setup(with: ChatViewModel(from: chat))

            }.disposed(by: disposeBag)
    }
}

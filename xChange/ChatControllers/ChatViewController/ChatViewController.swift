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
        let output = viewModel.transform(ChatViewModel.Input(itemSelectedTrigger: contentView.tableView.rx.itemSelected.asDriver(),
                                                             itemDeletedTrigger: contentView.tableView.rx.itemDeleted.asDriver()))
        
        output.onChats
            .drive(contentView.tableView.rx.items(cellIdentifier: ChatTableViewCell.reuseIdentifier)) { [weak self] _, chat, cell in
                
                guard let cell = cell as? ChatTableViewCell,
                      let userId = self?.viewModel.authProvider.currentUserID() else { return }
                cell.setup(with: ChatSubjectViewModel(from: chat, unread: chat.hasNewMessage.contains(userId)))

            }.disposed(by: disposeBag)
        
        output.onChats
            .drive(onNext: { [weak self] xChanges in
                self?.contentView.setupContent(for: xChanges.count > 0)
            }).disposed(by: disposeBag)
        
        output.onItemSelected
            .drive (onNext:{ [weak self] chatId in
                guard let chatId = chatId else { return }
                self?.delegate?.didSelectGoToDirectChat(with: chatId)
            })
            .disposed(by: disposeBag)

        output.onItemDeleted
            .drive()
            .disposed(by: disposeBag)
        
        output.onUnreadMessage
            .throttle(.seconds(1))
            .drive(onNext:{ [weak self] unreadMessages in
                if let unread = unreadMessages, unread > 0 {
                    self?.tabBarItem.badgeValue = "\(unread)"
                } else {
                    self?.tabBarItem.badgeValue = nil
                }
            }).disposed(by: disposeBag)
    }
}

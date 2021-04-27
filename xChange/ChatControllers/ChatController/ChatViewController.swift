//
//  ChatViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import RxCocoa
import RxSwift
import UIKit

class ChatViewController: UIViewController {
    var viewModel:ChatViewModel!
    let disposeBag = DisposeBag()
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
    }
    
    private func setupObservables() {
        let output = viewModel.transform(ChatViewModel.Input())
        
        output.chats
            .drive(chatTableView.rx.items(cellIdentifier: "chatcell")) { _, chat, cell in
                
                cell.textLabel?.text = chat.id

            }.disposed(by: disposeBag)
    }
}

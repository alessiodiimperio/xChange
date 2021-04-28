//
//  ProfileViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProfileViewControllerDelegate: class {
    func didSelectSignOut()
}

class ProfileViewController: BaseViewController {
    
    weak var delegate: ProfileViewControllerDelegate?
    var viewModel:ProfileViewModel
    let contentView = ProfileView()
    let signOutButton = UIBarButtonItem()
    
    init(viewModel: ProfileViewModel, delegate: ProfileViewControllerDelegate?) {
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
        setupObservables()
        let signOutLabel = UILabel()
        signOutLabel.text = "Sign Out"
        signOutButton.customView = signOutLabel
        navigationItem.rightBarButtonItem = signOutButton
    }
}
//MARK: Bindings
extension ProfileViewController{
    private func setupObservables(){
        
        let input = ProfileViewModel.Input(deleteItemTrigger: contentView.tableView.rx.itemDeleted.asDriver(),
                                           signOutTrigger: signOutButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
    
        output.onUserXChanges
            .drive(contentView.tableView.rx
                    .items(cellIdentifier: XChangeTableViewCell.reuseIdentifier)){ index, xChange, cell in
                
                guard let cell = cell as? XChangeTableViewCell else { return }
                cell.setup(with: XChangeCellViewModel(from: xChange))
                
        }.disposed(by: disposeBag)
        
        output.onsignOutTapped
            .drive(onNext: {[weak self] in
                self?.delegate?.didSelectSignOut()
            })
            .disposed(by: disposeBag)
        
        output.onUserXChanges
            .drive(onNext: {[weak self] xchanges in
                xchanges.count > 0 ? self?.contentView.showTableView() : self?.contentView.showEmptyView()
            }).disposed(by: disposeBag)
        
        output.onDeleteItem.drive().disposed(by: disposeBag)
        
        output.onUser
            .map { $0 == nil }
            .drive(contentView.emailLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.onUser
            .map { $0 == nil }
            .drive(contentView.userNameLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.onUser
            .drive(onNext: {[weak self] user in
                guard let user = user else {
                    return
                }
                self?.contentView.emailLabel.text = user.email
                self?.contentView.userNameLabel.text = user.username
            })
            .disposed(by: disposeBag)
        
    }
}

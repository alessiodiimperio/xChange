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
    func didSelectGoToDetailView(for xChange: XChange)
}

class ProfileViewController: BaseViewController {
    
    weak var delegate: ProfileViewControllerDelegate?
    var viewModel:ProfileViewModel
    let contentView = ProfileView()
    let signOutButton = UIButton()
    
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
        setupSignOutButtonInNavigationBar()
        contentView.setup(with: viewModel)
    }
    
    private func setupSignOutButtonInNavigationBar() {
        signOutButton.setTitle(viewModel.signOutButtonTitle, for: .normal)
        signOutButton.setTitleColor(.mainClickableTintColor, for: .normal)
        let barButtonItem = UIBarButtonItem(customView: signOutButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func setupObservables(){
        super.setupObservables()
        
        let input = ProfileViewModel.Input(itemSelectedTrigger: contentView.tableView.rx.itemSelected.asDriver(),
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
                self?.contentView.setupContent(for: xchanges.count > 0)
            }).disposed(by: disposeBag)
                        
        output.onUser
            .drive(onNext: {[weak self] user in
                if let user = user {
                    self?.contentView.showUserLabels()
                    self?.contentView.emailLabel.text = user.email
                    self?.contentView.userNameLabel.text = user.username
                } else {
                    self?.contentView.hideUserLabels()
                }
            })
            .disposed(by: disposeBag)
        
        output.onItemSelected
            .drive(onNext: { [weak self] xChange in
                self?.delegate?.didSelectGoToDetailView(for: xChange)
            }).disposed(by: disposeBag)
    }
}

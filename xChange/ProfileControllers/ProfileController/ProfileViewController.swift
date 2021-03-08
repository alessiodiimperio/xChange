//
//  ProfileViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    var coordinator:ProfileCoordinator?
    let disposeBag = DisposeBag()
    var viewModel:ProfileViewModel!
    
    @IBOutlet weak var signOutNavBtn: UIBarButtonItem!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var userXChangesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupObservables()
    }
    
    private func setupLayout() {
        emptyLabel.text = "Empty..."
    }
}
//MARK: Bindings
extension ProfileViewController{
    private func setupObservables(){
        
        let input = ProfileViewModel.Input(deleteItemTrigger: userXChangesTableView.rx.itemDeleted.asDriver(),
                                           signOutTrigger: signOutNavBtn.rx.tap.asDriver())
        let output = viewModel.transform(input)
    
        output.onUserXChanges
            .drive(userXChangesTableView.rx
                .items(cellIdentifier: "XChangeCell")){ index, xChange, cell in
                cell.textLabel?.text = xChange.title
        }.disposed(by: disposeBag)
        
        output.onsignOutTapped
            .drive(onNext: {[weak self] in
                self?.coordinator?.didSelectSignOut()
            })
            .disposed(by: disposeBag)
        
        output.onUserXChanges
            .drive(onNext: {[weak self] xchanges in
                xchanges.count > 0 ? self?.showXchangesTableView() : self?.showEmptyView()
            }).disposed(by: disposeBag)
        
        output.onDeleteItem.drive().disposed(by: disposeBag)
        
    }
    
    private func showEmptyView() {
        userXChangesTableView.isHidden = true
        emptyLabel.isHidden = false
    }
    
    private func showXchangesTableView() {
        userXChangesTableView.isHidden = false
        emptyLabel.isHidden = true
    }
}

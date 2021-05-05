//
//  MainViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import Alamofire
import AlamofireImage
import RxSwift
import RxCocoa
import UIKit

protocol MainViewControllerDelegate: class {
    func handleDidSelectTableViewItem(xChange: XChange)
}

final class MainViewController: BaseViewController {
    var viewModel: MainViewModel
    let contentView: MainView
    weak var delegate: MainViewControllerDelegate?
        
    init(view: MainView, viewModel: MainViewModel, delegate: MainViewControllerDelegate?) {
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
        
        let input = MainViewModel.Input(searchTrigger: Driver.empty(),
                                        selectItemTrigger: contentView.tableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.onFeed
            .drive(contentView.tableView.rx.items(cellIdentifier: XChangeTableViewCell.reuseIdentifier)) { _, xChange, cell in
                
                guard let cell = cell as? XChangeTableViewCell else { return }
                cell.setup(with: XChangeCellViewModel(from: xChange))

            }.disposed(by: disposeBag)
        
        output.onItemSelect
            .drive(onNext: { [weak self] xChange in
                self?.delegate?.handleDidSelectTableViewItem(xChange: xChange)
            })
            .disposed(by: disposeBag)
    }
}

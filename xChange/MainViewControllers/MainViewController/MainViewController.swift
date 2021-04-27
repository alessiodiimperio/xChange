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

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: MainViewModel!
    
    weak var delegate: MainViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupObservers()
    }
    
    private func setupLayout() {
    }
    
    private func setupObservers() {
        let input = MainViewModel.Input(searchTrigger: Driver.empty(),
                                        selectItemTrigger: tableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.onFeed
            .drive(tableView.rx.items(cellIdentifier: XChangeMainTableViewCell.reuseIdentifier)) { _, xChange, cell in
                
                guard let cell = cell as? XChangeMainTableViewCell else { return }
                cell.setup(with: MainCellViewModel(from: xChange))

            }.disposed(by: disposeBag)
        
        output.onItemSelect
            .drive(onNext: { [weak self] xChange in
                print("item selected")
                self?.delegate?.handleDidSelectTableViewItem(xChange: xChange)
            })
            .disposed(by: disposeBag)
    }
}

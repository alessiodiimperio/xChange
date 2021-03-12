//
//  MainViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import RxSwift
import RxCocoa
import UIKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel:MainViewModel!
    
    @IBOutlet weak var xChangeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupObservers()
    }
    
    private func setupLayout() {
        
    }
    
    private func setupObservers() {
        let input = MainViewModel.Input(searchTrigger: Driver.empty(),
                                        selectItemTrigger: xChangeTableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.onFeed
            .drive(xChangeTableView.rx.items(cellIdentifier: "xchangeCell")) { _, item, cell in
                cell.textLabel?.text = item.title
            }.disposed(by: disposeBag)
        
        output.onItemSelect
            .drive()
            .disposed(by: disposeBag)
    }
}

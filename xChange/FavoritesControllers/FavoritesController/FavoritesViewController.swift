//
//  FavoritesViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import RxSwift
import RxCocoa
import UIKit

class FavoritesViewController: BaseViewController {

    let viewModel:FavoritesViewModel
    let contentView = FavoritesView()
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
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
        
        let input = FavoritesViewModel.Input(favoredItemTrigger: contentView.tableView.rx.itemSelected.asDriver(),
                                             favouriteToggleTrigger: contentView.tableView.rx.itemDeleted.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.onFavourites
            .drive(contentView.tableView.rx.items(cellIdentifier: XChangeTableViewCell.reuseIdentifier)) { _, xChange, cell in
                
                guard let cell = cell as? XChangeTableViewCell else { return }
                cell.setup(with: XChangeCellViewModel(from: xChange))
                
            }.disposed(by: disposeBag)
        
        output.onFavoriteToggle.drive().disposed(by: disposeBag)
    }
}

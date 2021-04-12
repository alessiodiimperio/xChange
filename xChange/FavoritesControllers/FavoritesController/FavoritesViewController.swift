//
//  FavoritesViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import RxSwift
import RxCocoa
import UIKit

class FavoritesViewController: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel:FavoritesViewModel!
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupObservables()
    }
    
    private func setupLayout() {
        
    }
}

extension FavoritesViewController {
    private func setupObservables() {
        
        let input = FavoritesViewModel.Input(favoredItemTrigger: favoritesTableView.rx.itemSelected.asDriver(),
                                             favouriteToggleTrigger: favoritesTableView.rx.itemDeleted.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.onFavourites
            .drive(favoritesTableView.rx.items(cellIdentifier: XChangeFavoriteTableViewCell.reuseIdentifier)) { _, xChange, cell in
                
                guard let cell = cell as? XChangeFavoriteTableViewCell else { return }
                cell.setup(with: xChange)
                
            }.disposed(by: disposeBag)
        
        output.onFavoriteToggle.drive().disposed(by: disposeBag)
    }
}

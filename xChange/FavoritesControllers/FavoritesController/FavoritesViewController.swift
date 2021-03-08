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
                                             unfavorItemTrigger: favoritesTableView.rx.itemDeleted.asDriver(),
                                             selectItemnTrigger: favoritesTableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.onFavourites
            .drive(favoritesTableView.rx.items(cellIdentifier: "favouriteCell")) { _, item, cell in
                cell.textLabel?.text = item.title
            }.disposed(by: disposeBag)
        
        output.onFavoredItem
            .drive(onNext: {
                print("Favored")
            })
            .disposed(by: disposeBag)
        
        output.onUnfavouredItem
            .drive(onNext: {
                print("Unfavored")
            })
            .disposed(by: disposeBag)
    }
}

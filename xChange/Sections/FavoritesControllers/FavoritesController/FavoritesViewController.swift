//
//  FavoritesViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import RxSwift
import RxCocoa
import UIKit

protocol FavouritesViewControllerDelegate: AnyObject {
    func didSelectFavourite(_ xChange: XChange)
}

class FavoritesViewController: BaseViewController {

    let viewModel:FavoritesViewModel
    let contentView: FavoritesView
    weak var delegate: FavouritesViewControllerDelegate?
    
    init(view: FavoritesView, viewModel: FavoritesViewModel, delegate: FavouritesViewControllerDelegate?) {
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
        contentView.setup(with: viewModel)
    }

    override func setupObservables() {
        super.setupObservables()
        
        let input = FavoritesViewModel.Input(favouriteItemSelectedTrigger: contentView.tableView.rx.itemSelected.asDriver(),
                                             favouriteToggleTrigger: contentView.tableView.rx.itemDeleted.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.onFavourites
            .drive(contentView.tableView.rx.items(cellIdentifier: XChangeTableViewCell.reuseIdentifier)) { _, xChange, cell in
                
                guard let cell = cell as? XChangeTableViewCell else { return }
                cell.setup(with: XChangeCellViewModel(from: xChange))
                
            }.disposed(by: disposeBag)
        
        output.onFavoriteToggle.drive().disposed(by: disposeBag)
        
        output.onFavouriteSelected
            .drive(onNext: { [weak self] xChange in
                self?.delegate?.didSelectFavourite(xChange)
            }).disposed(by: disposeBag)
        
        output.onFavourites
            .drive(onNext: {[weak self] xChanges in
                self?.contentView.setupContent(for: xChanges.count > 0)
            }).disposed(by: disposeBag)
    }
}

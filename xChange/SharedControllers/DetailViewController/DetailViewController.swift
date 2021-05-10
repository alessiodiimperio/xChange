//
//  MainDetailViewController.swift
//  xChange
//
//  Created by Alessio on 2021-03-30.
//
import RxSwift
import RxCocoa
import UIKit

protocol DetailViewControllerDelegate: class {
    func didSelectGoToDirectChat(with chatId: String)
    func didSelectXchangeSold(in viewController: BaseViewController)
}

class DetailViewController: BaseViewController {
    
    let contentView:  DetailView
    var viewModel: DetailViewModel
    weak var delegate: DetailViewControllerDelegate?
    
    init(view: DetailView, viewModel: DetailViewModel, delegate: DetailViewControllerDelegate?) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupObservables() {
        super.setupObservables()
        
        let output = viewModel.transform(DetailViewModel.Input(favButtonTrigger: contentView.favoriteButton.rx.tap.asDriver(),
                                                               chatButtonTrigger: contentView.chatButton.rx.tap.asDriver(),
                                                               soldButtonTrigger: contentView.soldButton.rx.tap.asDriver()))

        output.onImage
            .drive(onNext: {[weak self] imageLink in
                if let url = imageLink {
                    self?.contentView.itemImageView.af.setImage(withURL: url)
                } else {
                    self?.contentView.itemImageView.image = self?.contentView.itemImageView.placeHolderPhoto()
                }
            })
            .disposed(by: disposeBag)

        output.onTitle
            .drive(contentView.titleLabel.textLabel.rx.text)
            .disposed(by: disposeBag)

        output.onAuthor
            .drive(contentView.authorLabel.textLabel.rx.text)
            .disposed(by: disposeBag)

        output.onDate
            .drive(contentView.dateLabel.textLabel.rx.text)
            .disposed(by: disposeBag)

        output.onDescription
            .drive(contentView.descriptionTextView.textView.rx.text)
            .disposed(by: disposeBag)

        output.onPrice
            .drive(contentView.priceLabel.textLabel.rx.text)
            .disposed(by: disposeBag)

        output.onIsFavourite
            .drive(onNext: {[weak self] isFavorite in
                isFavorite ?
                    self?.contentView.favoriteButton.setImage(self?.viewModel.favoredIconImage, for: .normal)
                    :
                    self?.contentView.favoriteButton.setImage(self?.viewModel.unfavoredIconImage, for: .normal)
            })
            .disposed(by: disposeBag)

        output.onFavButtonClicked.drive()
        .disposed(by: disposeBag)

        output.onContactSellerClicked.drive(onNext: { [weak self] chatId in
            guard let chatId = chatId else { return}
            self?.delegate?.didSelectGoToDirectChat(with: chatId)
        }).disposed(by: disposeBag)
        
        output.onIsUserXchange
            .drive(onNext: { [weak self] isUsers in
                self?.contentView.setup(if: isUsers)
            })
            .disposed(by: disposeBag)
        
        output.onSoldButtonClicked
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.delegate?.didSelectXchangeSold(in: self)
            })
            .disposed(by: disposeBag)
    }
}

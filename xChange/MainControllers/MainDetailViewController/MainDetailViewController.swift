//
//  MainDetailViewController.swift
//  xChange
//
//  Created by Alessio on 2021-03-30.
//
import RxSwift
import RxCocoa
import UIKit

class MainDetailViewController: BaseViewController {
    
    let contentView = MainDetailView()
    var viewModel: MainDetailViewModel
    
    init(viewModel: MainDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservables()
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func setupObservables() {
        let output = viewModel.transform(MainDetailViewModel.Input(favButtonTrigger: contentView.favoriteButton.rx.tap.asDriver(),
                                                                   chatButtonTrigger: contentView.chatButton.rx.tap.asDriver()))

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
                    self?.contentView.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    :
                    self?.contentView.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            })
            .disposed(by: disposeBag)

        output.onFavButtonClicked.drive()
        .disposed(by: disposeBag)

        output.onChatButtonClicked.drive(onNext: {[weak self] xChange in
            print("Start chatting about xchange:", xChange.id)
        }).disposed(by: disposeBag)
    }
}

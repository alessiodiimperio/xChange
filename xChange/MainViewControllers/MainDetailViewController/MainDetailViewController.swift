//
//  MainDetailViewController.swift
//  xChange
//
//  Created by Alessio on 2021-03-30.
//
import RxSwift
import RxCocoa
import UIKit

class MainDetailViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    var viewModel: MainDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupObservables()
    }
    
    private func setupLayout() {
        
    }
    
    private func setupObservables() {
        let output = viewModel.transform(MainDetailViewModel.Input(favButtonTrigger: favoriteButton.rx.tap.asDriver(),
                                                                   chatButtonTrigger: chatButton.rx.tap.asDriver()))
        
        output.onImage
            .drive(onNext: {[weak self] imageLink in
                if let url = imageLink {
                    self?.imageView.af.setImage(withURL: url)
                } else {
                    self?.imageView.image = self?.imageView.placeHolderPhoto()
                }
            })
            .disposed(by: disposeBag)
        
        output.onTitle
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.onAuthor
            .drive(authorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.onDate
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.onDescription
            .drive(descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.onPrice
            .drive(priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.onIsFavourite
            .drive(onNext: {[weak self] isFavorite in
                isFavorite ?
                    self?.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    :
                    self?.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal    )
            })
            .disposed(by: disposeBag)
        
        output.onFavButtonClicked.drive()
        .disposed(by: disposeBag)
        
        output.onChatButtonClicked.drive(onNext: {[weak self] xChange in
            print("Start chatting about xchange:", xChange.id)
        }).disposed(by: disposeBag)
    }
}

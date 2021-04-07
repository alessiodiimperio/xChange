//
//  XChangeProfileTableViewCell.swift
//  xChange
//
//  Created by Alessio on 2021-03-16.
//
import Alamofire
import AlamofireImage
import SnapKit
import UIKit

class XChangeMainTableViewCell: UITableViewCell {
    static let reuseIdentifier = "XChangeMainCell"
        
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.clipsToBounds = true
        itemImageView.contentMode = .scaleAspectFill
        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        imageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(150)
        })
    }
    
    func setup(with viewModel: MainCellViewModel) {
    
        if let url = viewModel.image {
            itemImageView?.af.setImage(withURL: url)
        } else {
            itemImageView?.image = UIImageView().placeHolderPhoto()
        }
        
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
    }
}

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

class XChangeFavoriteTableViewCell: UITableViewCell {
    static let reuseIdentifier = "XChangeFavoriteCell"
    
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
        // Configure the view for the selected state
    }
    
    private func setupConstraints() {
        imageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(150)
        })
    }
    
    func setup(with xChange: XChange) {
        if let date = xChange.timestamp {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        
        if let link = xChange.image,
              let url = URL(string: link) {
            itemImageView?.af.setImage(withURL: url)
        } else {
            itemImageView?.image = UIImageView().placeHolderPhoto()
        }
        
        titleLabel.text = xChange.title
        priceLabel.text = xChange.price ?? ""
    }
}

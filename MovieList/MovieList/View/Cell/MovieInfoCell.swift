//
//  MovieInfoCell.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//

import UIKit
import SDWebImage

class MovieInfoCell: UITableViewCell {
    
    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var thumbnailView: UIImageView!
    @IBOutlet weak private var releaseDateLbl: UILabel!
    @IBOutlet weak private var ratingLbl: UILabel!
    
    public var item: MovieCellViewModel! {
        didSet {
            
            thumbnailView.sd_setImage(with: item.poster, completed: nil)
            titleLbl.text = item.title
            releaseDateLbl.text = item.releaseDate
            ratingLbl.text = item.rating
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  PostCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/09/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import Kingfisher
import UIKit

class PostCell: UITableViewCell {

	// MARK: - Properties -

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var subheadlineLabel: UILabel!

	// MARK: - Methods -

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configurePost(_ object: Posts) {
        headlineLabel?.text = object.title

        if object.categorias.contains("Destaques") == false {
            if subheadlineLabel != nil {
                subheadlineLabel?.text = object.excerpt
            }
        }

        // Lazy load of image from Marvel server
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: "image_Logo"))
    }

}

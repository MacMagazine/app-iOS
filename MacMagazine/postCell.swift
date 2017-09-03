//
//  postCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/09/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import UIKit

class postCell: UITableViewCell {
    
    // MARK: - Properties -

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var subheadlineLabel: UILabel!
    
    // MARK: - Methods -

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

import UIKit

class PostCell: UITableViewCell {
    
    // MARK: - Properties -

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var subheadlineLabel: UILabel!
	@IBOutlet weak var spin: UIActivityIndicatorView!
	
    // MARK: - Class Methods -

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

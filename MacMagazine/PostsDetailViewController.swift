import UIKit

// MARK: - PostsDetailViewController -

class PostsDetailViewController: UIViewController {

    // MARK: - Properties -
    
	@IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var detailItem: Posts? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
	
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
		super.viewDidLoad()
		self.configureView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

    // MARK: - Class Methods -
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    
}

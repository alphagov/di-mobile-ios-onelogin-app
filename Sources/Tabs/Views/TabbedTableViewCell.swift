import UIKit

class TabbedTableViewCell: UITableViewCell {
    var viewModel: TabbedViewCellModel? {
        didSet {
            textLabel?.text = viewModel?.cellTitle?.value
        }
    }
}

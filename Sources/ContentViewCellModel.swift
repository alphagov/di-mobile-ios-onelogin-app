import GDSCommon
 import UIKit

 struct ContentViewCellModel {
    var view: UIView?
    let action: (() -> Void)?

    init(view: UIView? = nil,
         action: (() -> Void)? = nil) {
        self.view = view
        self.action = action
    }
 }

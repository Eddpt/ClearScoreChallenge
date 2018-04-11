//  Copyright © 2018 Edgar Antunes. All rights reserved.

import UIKit

public protocol UIViewLoading {}

extension UIView: UIViewLoading {}

public extension UIViewLoading where Self: UIView {
    static func fromNib(nibNameOrNil: String? = nil) -> Self {
        let nibName = nibNameOrNil ?? className
        let nib = UINib(nibName: nibName, bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)

        // Find first object that is a view (there may be other objects, such as gesture recognizers)
        let selfs = objects.filter { $0 is Self }
        guard let object = selfs.first as? Self else {
            fatalError("No view found in nib \(nibName)")
        }
        return object
    }

    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }

    static var className: String {
        let className = "\(self)"
        let components = className.split { $0 == "." }.map(String.init)
        guard let name = components.last else {
            fatalError("Could not find className for \(className)")
        }
        return name
    }
}

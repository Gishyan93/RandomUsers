
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit

extension UIStackView {

  // MARK: - Methods
  public func removeAllArangedSubviews() {
    arrangedSubviews.forEach { $0.removeFromSuperview() }
  }
}


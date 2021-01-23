
//
//  Created by Tigran Gishyan on 12/1/20.
//

import Foundation

public enum OnboardingView {
  
    case randomuser
    case userpage
  
    public func hidesNavigationBar() -> Bool {
        switch self {
        default:
            return false
        }
    }
}

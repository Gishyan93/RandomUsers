
//
//  Created by Tigran Gishyan on 11/30/20.
//

import UIKit
import RxSwift

class RandomUsersAppDependencyContainer {
    // MARK: - Properties

    
    // MARK: - Methods
    public init() {
    }
    
    // Main
    // Factories needed to create a MainViewController.
    public func makeMainViewController() -> MainViewController {

        let onboardingViewController = makeOnboardingViewController()
        return MainViewController(
            onboardingViewController: onboardingViewController)
    }
    

    // Factories needed to create an OnboardingViewController.
    public func makeOnboardingViewController() -> OnboardingViewController {
      let dependencyContainer = RandomUsersOnboardingDependencyContainer(appDependencyContainer: self)
      return dependencyContainer.makeOnboardingViewController()
    }
}

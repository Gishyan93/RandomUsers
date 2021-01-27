
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit

public class MainViewController: NiblessViewController {
    
    // MARK: - Properties
    
    // Child View Controllers
    var onboardingViewController: OnboardingViewController
        
    // MARK: - Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presentOnboarding()
    }
    
    public init(onboardingViewController: OnboardingViewController) {
        self.onboardingViewController = onboardingViewController
        super.init()
    }
    
    
    public func presentOnboarding() {
        addFullScreen(childViewController: onboardingViewController)
    }
}


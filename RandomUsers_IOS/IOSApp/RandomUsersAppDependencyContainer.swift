
//
//  Created by Tigran Gishyan on 11/30/20.
//

import UIKit
import RxSwift

class RandomUsersAppDependencyContainer {
    // MARK: - Properties

    
    // Long-lived dependencies
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel
    
    // MARK: - Methods
    public init() {
        func makeUserSessionRepository() -> UserSessionRepository {
          let dataStore = makeUserSessionDataStore()
          let remoteAPI = makeAuthRemoteAPI()
          return RandomUsersUserSessionRepository(dataStore: dataStore,
                                             remoteAPI: remoteAPI)
        }
        
        
        func makeUserSessionDataStore() -> UserSessionDataStore {
          
          let coder = makeUserSessionCoder()
          return KeychainUserSessionDataStore(userSessionCoder: coder)
        }
        
        func makeUserSessionCoder() -> UserSessionCoding {
          return UserSessionPropertyListCoder()
        }
        
        func makeAuthRemoteAPI() -> AuthRemoteAPI {
            return CloudAuthenticationRemoteAPI()
        }

        func makeMainViewModel() -> MainViewModel {
          return MainViewModel()
        }

        self.sharedUserSessionRepository = makeUserSessionRepository()
        self.sharedMainViewModel = makeMainViewModel()
    }
    
    // Main
    // Factories needed to create a MainViewController.
   
    public func makeMainViewController() -> MainViewController {
        let launchViewController = makeLaunchViewController()
        let onboardingViewControllerFactory = {
            return self.makeOnboardingViewController()
        }
  
        return MainViewController(
            viewModel: sharedMainViewModel,
            launchViewController: launchViewController,
            onboardingViewControllerFactory: onboardingViewControllerFactory)
    }
    
    // Launching
    public func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(launchViewModelFactory: self)
    }

    
    public func makeLaunchViewModel() -> LaunchViewModel {
      return LaunchViewModel(userSessionRepository: sharedUserSessionRepository,
                             notSignedInResponder: sharedMainViewModel)
    }

    // Factories needed to create an OnboardingViewController.
    public func makeOnboardingViewController() -> OnboardingViewController {
      let dependencyContainer = RandomUsersOnboardingDependencyContainer(appDependencyContainer: self)
      return dependencyContainer.makeOnboardingViewController()
    }
    
}

extension RandomUsersAppDependencyContainer: LaunchViewModelFactory {}

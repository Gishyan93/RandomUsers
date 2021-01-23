
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit

public class RandomUsersOnboardingDependencyContainer {
    
    // MARK: - Properties
    
    // From parent container
    let sharedMainViewModel: MainViewModel
    
    // Long-lived dependencies
    let sharedOnboardingViewModel: OnboardingViewModel
    let groupsRemoteApi: RandomUsersRemoteAPI
    let fgroupsRepository: RandomUsersRepository
    
    let randomUsersViewModel: RandomUsersViewModel
    let userProfileViewModel: UserProfileViewModel
    let userProfileViewController: UserProfileViewController
        
    // MARK: - Methods
    init(appDependencyContainer: RandomUsersAppDependencyContainer) {
        func makeOnboardingViewModel() -> OnboardingViewModel {
            return OnboardingViewModel()
        }
        
        func getFgroupsRemoteAPI() -> RandomUsersRemoteAPI {
            return RandomUsersCloudRemoteAPI(userSession: RemoteUserSession(token: ""))
        }
        
        func fgroupsRepository(fgroupsRemoteAPI: RandomUsersRemoteAPI) -> RandomUsersRepository {
            let fgroupsRemoteAPI = getFgroupsRemoteAPI()
            return RandomUsersAppRepository(remoteAPI: fgroupsRemoteAPI)
        }

        self.sharedMainViewModel = appDependencyContainer.sharedMainViewModel
        
        self.sharedOnboardingViewModel = makeOnboardingViewModel()
        self.groupsRemoteApi = getFgroupsRemoteAPI()
        self.fgroupsRepository = fgroupsRepository(fgroupsRemoteAPI: self.groupsRemoteApi)
        
        self.randomUsersViewModel = RandomUsersViewModel(repository: self.fgroupsRepository,
                                                         selectUserResponder: sharedOnboardingViewModel)
        self.userProfileViewModel = UserProfileViewModel(repository: self.fgroupsRepository,
                                                         savingUserResponder: randomUsersViewModel)
        self.userProfileViewController = UserProfileViewController(viewModel: userProfileViewModel)
    }
    
    // Factories needed to create an OnboardingViewController.
    public func makeOnboardingViewController() -> OnboardingViewController {
        let randomUserViewController = makeRandomUserViewController()
        return OnboardingViewController(
            viewModel: sharedOnboardingViewModel,
            randomUserViewController: randomUserViewController,
            userProfileViewController: userProfileViewController)
    }
    
    // Welcome
    public func makeRandomUserViewController() -> RandomUsersViewController {
        return RandomUsersViewController(viewModel: randomUsersViewModel)
    }
    
}

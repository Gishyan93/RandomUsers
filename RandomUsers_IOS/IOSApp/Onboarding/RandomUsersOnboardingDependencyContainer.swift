
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit

public class RandomUsersOnboardingDependencyContainer {
    
    // MARK: - Properties
    
    // Long-lived dependencies
    let sharedOnboardingViewModel: OnboardingViewModel
    let groupsRemoteApi: RandomUsersRemoteAPI
    let ramdomUsersRepository: RandomUsersRepository
    
    let randomUsersViewModel: RandomUsersViewModel
    let userProfileViewModel: UserProfileViewModel
    let userProfileViewController: UserProfileViewController
        
    // MARK: - Methods
    init(appDependencyContainer: RandomUsersAppDependencyContainer) {
        func makeOnboardingViewModel() -> OnboardingViewModel {
            return OnboardingViewModel()
        }
        
        func randomUsersRemoteAPI() -> RandomUsersRemoteAPI {
            return RandomUsersCloudRemoteAPI()
        }
        
        func randomUsersRepository(fgroupsRemoteAPI: RandomUsersRemoteAPI) -> RandomUsersRepository {
            let fgroupsRemoteAPI = randomUsersRemoteAPI()
            return RandomUsersAppRepository(remoteAPI: fgroupsRemoteAPI)
        }
        
        self.sharedOnboardingViewModel = makeOnboardingViewModel()
        self.groupsRemoteApi = randomUsersRemoteAPI()
        self.ramdomUsersRepository = randomUsersRepository(
            fgroupsRemoteAPI: self.groupsRemoteApi)
        
        self.randomUsersViewModel = RandomUsersViewModel(
            repository: self.ramdomUsersRepository,
            selectUserResponder: sharedOnboardingViewModel)
        self.userProfileViewModel = UserProfileViewModel(
            repository: self.ramdomUsersRepository,
            savingUserResponder: randomUsersViewModel)
        self.userProfileViewController = UserProfileViewController(
            viewModel: userProfileViewModel)
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

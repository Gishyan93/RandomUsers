
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit
import PromiseKit
import RxSwift

public class OnboardingViewController: NiblessNavigationController {
    
    // MARK: - Properties
    // View Model
    let viewModel: OnboardingViewModel
    let disposeBag = DisposeBag()
    
    // Child View Controllers
    let randomUsersViewController: RandomUsersViewController
    let userProfileViewController: UserProfileViewController
    
    // MARK: - Methods
    init(viewModel: OnboardingViewModel,
         randomUserViewController: RandomUsersViewController,
         userProfileViewController: UserProfileViewController) {
        self.viewModel = viewModel
        self.randomUsersViewController = randomUserViewController
        self.userProfileViewController = userProfileViewController
        super.init()
        self.delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        subscribe(to: viewModel.view)
        subscribeToSelectedUsers(to: viewModel.selectedUser)
    }
    
    
    func subscribe(to observable: Observable<OnboardingNavigationAction>) {
        observable
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] action in
                guard let strongSelf = self else { return }
                strongSelf.respond(to: action)
            }).disposed(by: disposeBag)
    }
    
    func subscribeToSelectedUsers(to observable: Observable<RandomUserProfile>) {
        observable
            .subscribe(onNext: { [weak self] user in
                guard let strongSelf = self else { return }
                strongSelf.userProfileViewController.selectedUserSubject.onNext(user)
            }).disposed(by: disposeBag)
    }
    
    func respond(to navigationAction: OnboardingNavigationAction) {
        switch navigationAction {
        case .present(let view):
            present(view: view)
        case .presented:
            break
        }
    }
    
    func present(view: OnboardingView) {
        switch view {
        case .randomuser:
            presentRandomUsers()
        case .userpage:
            presentUserPage()
        }
    }
    
    func presentRandomUsers() {
        pushViewController(randomUsersViewController, animated: false)
    }
    
    func presentUserPage() {
        pushViewController(userProfileViewController, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension OnboardingViewController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        guard let shownView = onboardingView(associatedWith: viewController) else { return }
        viewModel.uiPresented(onboardingView: shownView)
    }
}

extension OnboardingViewController {
    
    func onboardingView(associatedWith viewController: UIViewController) -> OnboardingView? {
        switch viewController {
        case is RandomUsersViewController:
            return .randomuser
        case is UserProfileViewController:
            return .userpage
        default:
            assertionFailure("Encountered unexpected child view controller type in OnboardingViewController")
            return nil
        }
    }
}

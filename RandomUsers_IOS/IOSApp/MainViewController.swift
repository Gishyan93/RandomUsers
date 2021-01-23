
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit
import PromiseKit
import RxSwift

public class MainViewController: NiblessViewController {

  // MARK: - Properties
  // View Model
  let viewModel: MainViewModel

  // Child View Controllers
  let launchViewController: LaunchViewController
  var onboardingViewController: OnboardingViewController?

  // State
  let disposeBag = DisposeBag()

  // Factories
  let makeOnboardingViewController: () -> OnboardingViewController

  // MARK: - Methods
    
    public init(
        viewModel: MainViewModel,
        launchViewController: LaunchViewController,
        onboardingViewControllerFactory: @escaping () -> OnboardingViewController) {
      self.viewModel = viewModel
      self.launchViewController = launchViewController
      self.makeOnboardingViewController = onboardingViewControllerFactory
      super.init()
    }
  

  func subscribe(to observable: Observable<MainView>) {
    observable
      .subscribe(onNext: { [weak self] view in
        guard let strongSelf = self else { return }
        strongSelf.present(view)
      })
      .disposed(by: disposeBag)
  }

  public func present(_ view: MainView) {
    switch view {
    case .launching:
      presentLaunching()
    case .onboarding:
      if onboardingViewController?.presentingViewController == nil {
        if presentedViewController.exists {
          dismiss(animated: true) { [weak self] in
            self?.presentOnboarding()
          }
        } else {
          presentOnboarding()
        }
      }
    }
   
  }

  public func presentLaunching() {
    addFullScreen(childViewController: launchViewController)
  }

  public func presentOnboarding() {
    let onboardingViewController = makeOnboardingViewController()
    onboardingViewController.modalPresentationStyle = .fullScreen
    present(onboardingViewController, animated: true) { [weak self] in
      guard let strongSelf = self else {
        return
      }

      strongSelf.remove(childViewController: strongSelf.launchViewController)

    }
    self.onboardingViewController = onboardingViewController
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    observeViewModel()
  }

  private func observeViewModel() {
    let observable = viewModel.view.distinctUntilChanged()
    subscribe(to: observable)
  }
}



//
//  Created by Tigran Gishyan on 12/1/20.
//

import Foundation
import RxSwift

public typealias OnboardingNavigationAction = NavigationAction<OnboardingView>

public class OnboardingViewModel: SelectUserResponder {
    
    
    // MARK: - Properties
    public var view: Observable<OnboardingNavigationAction> { return _view.asObservable() }
    private let _view = BehaviorSubject<OnboardingNavigationAction>(value: .present(view: .randomuser))
    
    public var selectedUser: Observable<RandomUserProfile> {
        return selectedUserSubject
    }
    
    private let selectedUserSubject = PublishSubject<RandomUserProfile>()
    
    // MARK: - Methods
    public init() {}
    
    public func uiPresented(onboardingView: OnboardingView) {
        _view.onNext(.presented(view: onboardingView))
    }
    
    public func selectUser(userInfo: RandomUserProfile) {
        _view.onNext(.present(view: .userpage))
        self.selectedUserSubject.onNext(userInfo)
    }
    
}


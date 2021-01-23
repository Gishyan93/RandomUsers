
//
//  Created by Tigran Gishyan on 11/30/20.
//

import Foundation
import RxSwift

public class MainViewModel: NotSignedInResponder {
  // MARK: - Properties
  public var view: Observable<MainView> { return viewSubject.asObservable() }
  private let viewSubject = BehaviorSubject<MainView>(value: .launching)

  // MARK: - Methods
  public init() {}

  public func notSignedIn() {
    viewSubject.onNext(.onboarding)
  }
}

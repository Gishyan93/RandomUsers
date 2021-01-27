//
//  UserProfileViewController.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/15/21.
//

import UIKit
import RxSwift
import Kingfisher

public class UserProfileViewController: NiblessViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel: UserProfileViewModel
    
    public var selectedUser: Observable<RandomUserProfile> {
        return selectedUserSubject.asObservable()
    }
    let selectedUserSubject = BehaviorSubject<RandomUserProfile>(value: RandomUserProfile())
    //
    
    // Root View
    var userProfileRootView: UserProfileRootView {
      return view as! UserProfileRootView
    }
    
    // MARK: - Methods
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        
      super.init()
    }
    
    public override func loadView() {
        self.view = UserProfileRootView(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedUser
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected search results observable error.") })
            .drive(onNext: { [weak self] user in
                guard let strongSelf = self else {return}
                strongSelf.viewModel.selectedUser.onNext(user)
            })
            .disposed(by: disposeBag)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigatioBar()
    }
    
    private func setupNavigatioBar() {
        self.navigationController?.navigationBar.topItem?.title = "Users"
    }
}

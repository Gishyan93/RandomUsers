
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit
import RxSwift

public class RandomUsersViewController: NiblessViewController {
    //
    // MARK: - Properties
    //
    let disposeBag = DisposeBag()
    let viewModel: RandomUsersViewModel
    
    let randomUsersView: RandomUsersView
    let savedUsersView: SavedUsersView
    
    // Child Views
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Users", "Saved Users"]
        let control = UISegmentedControl(items: items)
        let width = view.frame.size.width/2
        control.setWidth(width, forSegmentAt: 0)
        control.setWidth(width, forSegmentAt: 1)
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
        control.addTarget(self, action: #selector(indexChanged), for: .allEvents)
        return control
    }()
    //
    // MARK: - Methods
    //
    init(viewModel: RandomUsersViewModel) {
        self.viewModel = viewModel
        self.randomUsersView = RandomUsersView(viewModel: viewModel)
        self.savedUsersView = SavedUsersView(viewModel: viewModel)
        super.init()
    }
    
    public override func loadView() {
        view = UIView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(randomUsersView)
        randomUsersView.fillSuperview()
        observeErrorMessages()
       
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = segmentedControl
    }
    
    
    @objc
    func indexChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            savedUsersView.removeFromSuperview()
            view.addSubview(randomUsersView)
            randomUsersView.fillSuperview()
        } else {
            randomUsersView.removeFromSuperview()
            view.addSubview(savedUsersView)
            savedUsersView.fillSuperview()
        }
    }
    
    func observeErrorMessages() {
      viewModel
        .errorMessages
        .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
        .drive(onNext: { [weak self] errorMessage in
          self?.present(errorMessage: errorMessage)
        })
        .disposed(by: disposeBag)
    }
}



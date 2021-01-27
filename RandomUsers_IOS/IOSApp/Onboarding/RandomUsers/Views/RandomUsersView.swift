
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit
import RxSwift
import RxCocoa

final class RandomUsersView: NiblessView {
    //
    // MARK: - Properties
    //
    let viewModel: RandomUsersViewModel
    let disposeBag = DisposeBag()
    
    var randomUsers: Observable<[RandomUserInfo]> {
        return randomUsersRelay.asObservable()
    }
    var randomUsersRelay = BehaviorRelay(value: [RandomUserInfo]())
    var shownUsers = [RandomUserInfo]()
    var allUsers = [RandomUserInfo]()
    var isPaginating: Bool = true
    var isSearching: Bool = false
    
    private let cellID = "cellID"
    private let footerID = "footerID"
    
    private let verticalInset: CGFloat = 0
    private let horizontalInset: CGFloat = 0
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset)
        return flowLayout
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            RandomUserCell.self,
            forCellWithReuseIdentifier: cellID)
        collectionView.register(RandomUserLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID)
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .appUltraLightGray
        return collectionView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = .black
        searchBar.barTintColor = .appUltraLightGray
        searchBar.backgroundColor = .appUltraLightGray
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = searchBar.barTintColor?.cgColor
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    let separatorLine: UIView = {
        let separator = UIView()
        separator.setHeight(1)
        separator.backgroundColor = .appGray
        return separator
    }()
    
    // MARK: - Initializers
    init(frame: CGRect = .zero,
         viewModel: RandomUsersViewModel) {
        
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .appUltraLightGray
        setupSearchBar()
        setupSeparatorLine()
        setupCollectionView()
        
        viewModel.loadRandomUsers()
        
        viewModel.randomUsers
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected view model search results observable error.") })
            .drive(onNext: { [weak self] users in
                guard let strongSelf = self else {return}
                //Accepting new values
                strongSelf.randomUsersRelay.accept(users)
            })
            .disposed(by: disposeBag)
        
        randomUsers
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected search results observable error.") })
            .drive(onNext: { [weak self] _ in
                    guard let strongSelf = self else {return}
                    strongSelf.allUsers = strongSelf.allUsers + strongSelf.randomUsersRelay.value
                    strongSelf.shownUsers = strongSelf.allUsers
                    
                    strongSelf.collectionView.reloadData()
                    strongSelf.isPaginating = true
            })
            .disposed(by: disposeBag)
        
    }
    
    
    // MARK: - Layouts
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupSearchBar() {
        addSubview(searchBar)
        searchBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 4, bottom: 0, right: 4))
        
        
        searchBar
            .rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                
                if query.count < 2 {
                    self.shownUsers = self.allUsers
                    self.isSearching = false
                } else {
                    isSearching = true
                    self.shownUsers = self.allUsers.filter {
                        (($0.name.first.lowercased().contains(query.lowercased())))
                            ||
                            (($0.name.last.lowercased().contains(query.lowercased())))
                            ||
                            (($0.gender.lowercased().hasPrefix(query.lowercased())))
                            ||
                            (($0.phone.lowercased().contains(query.lowercased())))
                            ||
                            (($0.location.country.lowercased().contains(query.lowercased())))
                            ||
                            $0.location.street.name.lowercased().contains(query.lowercased())
                            ||
                            String($0.location.street.number).lowercased().contains(query.lowercased())
                    }
                }
                
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setupSeparatorLine() {
        addSubview(separatorLine)
        separatorLine.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.anchor(top: separatorLine.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
    
}

// MARK: - UICollectionViewDataSource
extension RandomUsersView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shownUsers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView .dequeueReusableCell(
            withReuseIdentifier: cellID,
            for: indexPath) as? RandomUserCell
        
        cell?.randomUser = shownUsers[indexPath.item]
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerID, for: indexPath)
        return footer
    }
    
    
}

extension RandomUsersView: UICollectionViewDelegateFlowLayout {
    //sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return .init(width: UIScreen.main.bounds.width, height: 110)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isSearching ? 0 : 130
        return .init(width: bounds.width, height: height)
    }
    
}

// MARK: - UICollectionViewDelegate
extension RandomUsersView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.passUserInfo(info: self.shownUsers[indexPath.item])
    }
}


extension RandomUsersView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentSize = (collectionView.contentSize.height - 5 - scrollView.frame.size.height)
        
        if position > contentSize && (isPaginating) {

            //Starting to fetch
            isPaginating = false
            viewModel.loadMoreUsers()

        }
    }
}

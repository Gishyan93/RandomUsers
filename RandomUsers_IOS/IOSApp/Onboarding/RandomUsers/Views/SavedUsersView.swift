//
//  SavedUsersView.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/21/21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

final class SavedUsersView: NiblessView {
    //
    // MARK: - Properties
    //
    let viewModel: RandomUsersViewModel
    let disposeBag = DisposeBag()
    
    var savedUsers: Observable<[Person]> {
        return savedUsersRelay.asObservable()
    }
    var savedUsersRelay = BehaviorRelay(value: [Person]())
    
    var removedUsers: Observable<[Person]> {
        return removedUsersRelay.asObservable()
    }
    var removedUsersRelay = BehaviorRelay(value: [Person]())
    
    var shownUsers = [Person]()
    var allUsers = [Person]()
    
    var isSearching: Bool = false
    
    private let cellID = "cellID"
    
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
            SavedUserCell.self,
            forCellWithReuseIdentifier: cellID)
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
    //
    // MARK: - Functions
    //
    init(frame: CGRect = .zero,
         viewModel: RandomUsersViewModel) {
        
        self.viewModel = viewModel
        super.init(frame: frame)
        
        subscribingToSavedUsers()
        subscribingToRemovedUsers()
        searchBarBinding()
    }
    
    private func subscribingToSavedUsers() {
        viewModel.savedUsers
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected view model search results observable error.") })
            .drive(onNext: { [weak self] users in
                guard let strongSelf = self else {return}
                //Accepting new values
                strongSelf.savedUsersRelay.accept(users)
            })
            .disposed(by: disposeBag)
        
        savedUsers
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected search results observable error.") })
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else {return}
                let fetchedUsers: NSFetchRequest<Person> = Person.fetchRequest()
                
                do {
                    let savedUsers = try PersistanceService.context.fetch(fetchedUsers)
                    strongSelf.allUsers = savedUsers
                    strongSelf.shownUsers = strongSelf.allUsers
                } catch {
                    fatalError("Error fetching data from Person class")
                }
                strongSelf.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribingToRemovedUsers() {
        viewModel.removedUsers
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected view model search results observable error.") })
            .drive(onNext: { [weak self] user in
                guard let strongSelf = self else {return}
                //Accepting new values
                strongSelf.removedUsersRelay.accept(user)
            })
            .disposed(by: disposeBag)
        
        removedUsers
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected search results observable error.") })
            .drive(onNext: { [weak self] user in
                guard let strongSelf = self else {return}
                
                let fetchedUsers: NSFetchRequest<Person> = Person.fetchRequest()
                
                do {
                    let removedUsers = try PersistanceService.context.fetch(fetchedUsers)
                    strongSelf.allUsers = removedUsers
                    strongSelf.shownUsers = strongSelf.allUsers
                } catch {
                    fatalError("Error fetching data from Person class")
                }
                strongSelf.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func searchBarBinding() {
        
        searchBar
            .rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                
                //Rewrite this part
                if query.count < 2 {
                    self.shownUsers = self.allUsers
                    self.isSearching = false
                } else {
                    isSearching = true
                    self.shownUsers = self.allUsers.filter {
                        (($0.firstname!.lowercased().contains(query.lowercased())))
                            ||
                            (($0.lastname!.lowercased().contains(query.lowercased())))
                            ||
                            (($0.gender!.lowercased().hasPrefix(query.lowercased())))
                            ||
                            (($0.phone!.lowercased().contains(query.lowercased())))
                            ||
                            (($0.country!.lowercased().contains(query.lowercased())))
                            ||
                            $0.street!.lowercased().contains(query.lowercased())
                    }
                }
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .appUltraLightGray
        constructHierarchy()
        activateConstraints()
    }
    
    private func constructHierarchy() {
        addSubview(searchBar)
        addSubview(separatorLine)
        addSubview(collectionView)
    }
    
    private func activateConstraints() {
        activateConstraintsSearchBar()
        activateConstraintsSeparatorLine()
        activateConstraintsCollectionView()
    }
    
    private func activateConstraintsSearchBar() {
        searchBar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 4, bottom: 0, right: 4))
    }
    
    private func activateConstraintsSeparatorLine() {
        separatorLine.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    }
    
    private func activateConstraintsCollectionView() {
        collectionView.anchor(top: separatorLine.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
    
}

// MARK: - UICollectionViewDataSource
extension SavedUsersView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shownUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(
            withReuseIdentifier: cellID,
            for: indexPath) as? SavedUserCell
        cell?.randomUser = shownUsers[indexPath.item]
        return cell!
    }
}

extension SavedUsersView: UICollectionViewDelegateFlowLayout {
    //sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: UIScreen.main.bounds.width, height: 110)
    }
}

// MARK: - UICollectionViewDelegate
extension SavedUsersView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let streetnumber = shownUsers[indexPath.item].streetnumber
        
        if let id = shownUsers[indexPath.item].id,
           let gender = shownUsers[indexPath.item].gender,
           let firstname = shownUsers[indexPath.item].firstname,
           let lastname = shownUsers[indexPath.item].lastname,
           let city = shownUsers[indexPath.item].city,
           let country = shownUsers[indexPath.item].country,
           let street = shownUsers[indexPath.item].street,
           let latitude = shownUsers[indexPath.item].latitude,
           let longitude = shownUsers[indexPath.item].longitude,
           let phone = shownUsers[indexPath.item].phone,
           let picture = shownUsers[indexPath.item].picture {
            let savedUserInfo = RandomUserInfo(gender: gender, name: Name(first: firstname, last: lastname), location: UserLocation(street: Street(number: Int(streetnumber), name: street), city: city, country: country, coordinates: Coordinates(latitude: latitude, longitude: longitude)), login: Login(uuid: id), phone: phone, picture: Picture(large: picture))
            
            viewModel.passUserInfo(info: savedUserInfo)
        }
    }
}

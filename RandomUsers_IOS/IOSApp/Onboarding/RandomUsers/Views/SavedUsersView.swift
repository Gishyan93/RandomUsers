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
        flowLayout.minimumLineSpacing = 10
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
    
    // MARK: - Initializers
    init(frame: CGRect = .zero,
         viewModel: RandomUsersViewModel) {
        
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .appUltraLightGray
        setupSearchBar()
        setupSeparatorLine()
        setupCollectionView()
        
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
    
    private func setupSeparatorLine() {
        addSubview(separatorLine)
        separatorLine.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.anchor(top: separatorLine.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
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
        
        let dummyCell = SavedUserCell(frame: .init(x: 0, y: 0, width: bounds.width, height: 1000))
        
        dummyCell.randomUser = self.shownUsers[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: bounds.width, height: 1000))
        
        return .init(width: UIScreen.main.bounds.width, height: estimatedSize.height)
        
    }
}

// MARK: - UICollectionViewDelegate
extension SavedUsersView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = shownUsers[indexPath.item].id!
        let gender = shownUsers[indexPath.item].gender!
        let firstname = shownUsers[indexPath.item].firstname!
        let lastname = shownUsers[indexPath.item].lastname!
        let city = shownUsers[indexPath.item].city!
        let country = shownUsers[indexPath.item].country!
        let streetnumber = shownUsers[indexPath.item].streetnumber
        let street = shownUsers[indexPath.item].street!
        let latitude = shownUsers[indexPath.item].latitude!
        let longitude = shownUsers[indexPath.item].longitude!
        let phone = shownUsers[indexPath.item].phone!
        let picture = shownUsers[indexPath.item].picture!
       
        
        let savedUserInfo = RandomUserInfo(gender: gender, name: .init(title: "", first: firstname, last: lastname), location: .init(street: .init(number: Int(streetnumber), name: street), city: city, state: "", country: country, postcode: Postcode.integer(0), coordinates: .init(latitude: latitude, longitude: longitude), timezone: .init(offset: "", timezoneDescription: "")), email: "", login: .init(uuid: id, username: "", password: "", salt: "", md5: "", sha1: "", sha256: ""), dob: .init(date: "", age: 0), registered: .init(date: "", age: 0), phone: phone, cell: "", id: .init(name: "", value: ""), picture: .init(large: picture, medium: "", thumbnail: ""), nat: "")
        viewModel.passUserInfo(info: savedUserInfo)
    }
}

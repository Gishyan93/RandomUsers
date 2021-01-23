//
//  RandomUsersModel.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/15/21.
//

import Foundation
import RxSwift
import PromiseKit
import RxCocoa

public class RandomUsersViewModel: SavingUserResponder {
    
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let repository: RandomUsersRepository
    let selectUserResponder: SelectUserResponder
    
    public var randomUsers: Observable<[RandomUserInfo]> {
        return randomUsersRelay.asObservable()
    }
    private let randomUsersRelay = BehaviorRelay(value: [RandomUserInfo]())
    
    
    public var savedUsers: Observable<[Person]> {
        return savedUsersRelay.asObservable()
    }
    private let savedUsersRelay = BehaviorRelay(value: [Person]())
    
    public var removedUsers: Observable<[Person]> {
        return removedUsersRelay.asObservable()
    }
    private let removedUsersRelay = BehaviorRelay(value: [Person]())
    
    public let searchPage = BehaviorSubject<Int>(value: 2)
    public let isPaginating = BehaviorSubject<Bool>(value: true)
    
    
    //Error
    
    public var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    private let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    // MARK: - Methods
    public init(repository: RandomUsersRepository,
                selectUserResponder: SelectUserResponder) {
        self.repository = repository
        self.selectUserResponder = selectUserResponder
    }
    
    public func saveUser(userInfo: Person) {
        savedUsersRelay.accept([userInfo])
    }
    
    public func removeUser() {
        let users = [Person]()
        removedUsersRelay.accept(users)
    }
        
    public func loadRandomUsers() {
        repository.getRandomUsers()
            .done { [weak self] users in
                guard let strongSelf = self else {return}
                
                strongSelf.update(randomUsers: users.results)
            }
            .catch(handleFetchingUsersDataError)
    }
    
    public func loadMoreUsers() {
        paginationDesabled()
        do {
            let currentPageNumber = try searchPage.value()
            repository.getMoreUsers(pageNumber: currentPageNumber)
                .done { [weak self] users in
                    guard let strongSelf = self else {return}
                    strongSelf.update(randomUsers: users.results)
                    strongSelf.updateSearchPage()
                }
                .catch(handleFetchingUsersDataError)
        } catch {
            
        }
        
        
    }
    
    public func paginationDesabled() {
        isPaginating.onNext(false)
    }
    
    public func paginationEnabled() {
        isPaginating.onNext(true)
    }
    
    private func update(randomUsers: [RandomUserInfo]) {
        self.randomUsersRelay.accept(randomUsers)
    }
    
    private func updateSearchPage() {
        do {
            let curValue = try searchPage.value()
            self.searchPage.onNext(curValue + 1)
        } catch {
            fatalError("Error adding search page value by one.")
        }
    }
    
    
    func passUserInfo(info: RandomUserInfo) {
        let profile = RandomUserProfile(gender: info.gender, name: info.name, location: info.location, phone: info.phone, cell: info.cell, picture: info.picture, id: info.login.uuid)
        selectUserResponder.selectUser(userInfo: profile)
    }
    
    func handleFetchingUsersDataError(_ error: Error) {
      switch error as? RemoteAPIError {
      case .serverError:
          errorMessagesSubject.onNext(ErrorMessage(title: "Server error",
                                                   message: "Something went wrong. Please try again later."))
      default:
          errorMessagesSubject.onNext(ErrorMessage(title: "Error",
                                                   message: "Something went wront. Please try again later."))
      }
      
    }
    
    
    
}


//
//  UserProfileViewModel.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/15/21.
//

import Foundation
import RxSwift
import PromiseKit
import RxCocoa
import CoreData

public class UserProfileViewModel {
    
    // MARK: - Properties
    let repository: RandomUsersRepository
    let savingUserResponder: SavingUserResponder
    let disposeBag = DisposeBag()
    
    public let randomUsers = BehaviorSubject<[RandomUserInfo]>(value: [])
    public let saveUserButtonEnabled = BehaviorSubject<Bool>(value: true)
    public let removeUserButtonHidden = BehaviorSubject<Bool>(value: true)
    
    public let saveUserButtonColor = BehaviorSubject<UIColor>(value: .appGreen)
    
    let selectedUser = PublishSubject<RandomUserProfile>()
    
    let savedUser = PublishSubject<RandomUserProfile>()
        
    //Error
    public var errorMessages: Observable<ErrorMessage> {
        return errorMessagesSubject.asObserver()
    }
    private let errorMessagesSubject = PublishSubject<ErrorMessage>()
    
    // MARK: - Methods
    public init(repository: RandomUsersRepository,
                savingUserResponder: SavingUserResponder) {
        self.repository = repository
        self.savingUserResponder = savingUserResponder
    }
    
    
    public func loadRandomUsers() {
        repository.getRandomUsers()
            .done { [weak self] users in
                self?.update(randomUsers: users.results)
            }
            .catch { error in
                let errorMessage = ErrorMessage(title: "Oups",
                                                message: "Something went wrong.\nPlease try again.")
                self.errorMessagesSubject.onNext(errorMessage)
            }
    }
    
    private func update(randomUsers: [RandomUserInfo]) {
        self.randomUsers
            .onNext(randomUsers)
    }
    
    public func saveUser(savedUser: RandomUserProfile) {
        indicateSavingUser()
        buttonPressedColor()

        let user = Person(context: PersistanceService.context)
        user.id = savedUser.id
        user.firstname = savedUser.name.first
        user.lastname = savedUser.name.last
        user.gender = savedUser.gender
        user.city = savedUser.location.city
        user.country = savedUser.location.country
        user.street = savedUser.location.street.name
        user.streetnumber = Int16(savedUser.location.street.number)
        user.latitude = savedUser.location.coordinates.latitude
        user.longitude = savedUser.location.coordinates.longitude
        user.phone = savedUser.phone
        user.picture = savedUser.picture.large
        
        PersistanceService.saveContext()
        savingUserResponder.saveUser(userInfo: user)
           
    }
    
    
    public func removeUser(removedUser: RandomUserProfile) {
        indicateRemoveUser()
        
        let fetchedUsers: NSFetchRequest<Person> = Person.fetchRequest()
        
        let user = try? PersistanceService.context.fetch(fetchedUsers)
        
        if let user = user {
            for object in user {
                if removedUser.id == object.id {
                    PersistanceService.context.delete(object)
                }
            }
        }
        
        savingUserResponder.removeUser()
       
        
    }
    
    func indicateSavingUser() {
        saveUserButtonEnabled.onNext(false)
        removeUserButtonHidden.onNext(false)
    }
    
    func buttonPressedColor() {
        saveUserButtonColor.onNext(.appGray)
    }
    
    
    public func selectUser(userInfo: RandomUserProfile) {
        selectedUser.onNext(userInfo)
    }
    func indicateRemoveUser() {
        saveUserButtonEnabled.onNext(true)
        removeUserButtonHidden.onNext(true)
        saveUserButtonColor.onNext(.appGreen)
    }
    
    
}



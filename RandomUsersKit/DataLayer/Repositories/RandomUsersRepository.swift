//
//  FoodmeFgroupsRepository.swift
//  Foodme
//
//  Created by Tigran Gishyan on 12/31/20.
//
import Foundation
import PromiseKit

public class RandomUsersAppRepository: RandomUsersRepository {
        
    // MARK: - Properties
    let remoteAPI: RandomUsersRemoteAPI

    // MARK: - Methods
    public init(remoteAPI: RandomUsersRemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    public func getRandomUsers() -> Promise<RandomUsers> {
        return remoteAPI.getRandomUsers()
    }
    
    public func getMoreUsers(pageNumber: Int) -> Promise<RandomUsers> {
        let castedPageNumber = String(pageNumber)
        return remoteAPI.getMoreUsers(pageNumber: castedPageNumber)
    }
}


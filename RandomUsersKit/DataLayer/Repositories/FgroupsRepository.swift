//
//  FgroupsRepository.swift
//  Foodme
//
//  Created by Tigran Gishyan on 12/31/20.
//

import Foundation
import PromiseKit

public protocol RandomUsersRepository {
    func getRandomUsers() -> Promise<RandomUsers>
    func getMoreUsers(pageNumber: Int) -> Promise<RandomUsers>
}

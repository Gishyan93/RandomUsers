//
//  UserSessionRepository.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/21/21.
//

import Foundation
import PromiseKit

public protocol UserSessionRepository {
    
    func readUserSession() -> Promise<UserSession?>

}

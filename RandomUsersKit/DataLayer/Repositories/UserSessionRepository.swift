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
  func signUp(newAccount: NewAccount) -> Promise<UserSession>
  func signIn(email: String, password: String) -> Promise<UserSession>
  func signOut(userSession: UserSession) -> Promise<UserSession>
}

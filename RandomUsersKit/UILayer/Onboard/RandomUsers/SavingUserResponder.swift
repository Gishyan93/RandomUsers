//
//  SavingUserResponder.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/21/21.
//
import Foundation

public protocol SavingUserResponder {
    func saveUser(userInfo: Person)
    func removeUser()
}

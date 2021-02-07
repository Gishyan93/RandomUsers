//
//  RandomUserInfo.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/20/21.
//

import Foundation

// MARK: - Result
public struct RandomUserProfile {
    let gender: String
    let name: Name
    let location: UserLocation
    let phone, cell: String
    let picture: Picture
    let id: String
    
    init() {
        self.gender = ""
        self.name = Name(first: "", last: "")
        self.location = UserLocation(street: .init(number: 0, name: ""), city: "", country: "", coordinates: Coordinates(latitude: "", longitude: ""))
        self.phone = ""
        self.cell = ""
        self.picture = Picture(large: "")
        self.id = ""
    }
    
    init(gender: String,
         name: Name,
         location: UserLocation,
         phone: String,
         cell: String,
         picture: Picture,
         id: String) {
        self.gender = gender
        self.name = name
        self.location = location
        self.phone = phone
        self.cell = cell
        self.picture = picture
        self.id = id
    }
}

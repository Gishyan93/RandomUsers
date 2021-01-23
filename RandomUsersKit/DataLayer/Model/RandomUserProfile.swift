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
        self.name = Name(title: "", first: "", last: "")
        self.location = UserLocation(street: .init(number: 0, name: ""),
                                     city: "", state: "",
                                     country: "",
                                     postcode: Postcode.integer(0),
                                     coordinates: .init(latitude: "", longitude: ""),
                                     timezone: .init(offset: "", timezoneDescription: ""))
        self.phone = ""
        self.cell = ""
        self.picture = Picture(large: "", medium: "", thumbnail: "")
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
